"use strict"; // Can be omitted when using classes and modules as they enable it

function main() {

    let readline = require('readline');
    let parser = readline.createInterface({
        input: process.stdin,
        terminal: false
    });

    // This way we can read multiple lines if we want. Don't stop until EOF automatically
    parser.on('line', function(line){
        part1(line.split(',').map(Number));
        part2(getCharCodes(line));
    })
}

function pinchAndTwists(lengths, knots, pos, skip) {

    lengths.forEach((length) => {
        twist(pos, length, knots);

        pos = (pos + skip++ + length) % knots.length;
    })

    return [pos, skip];

}

function twist(pos, length, knots) {
    for (let i = 0; i < length/2; i++) {
        const ind1 = (pos + i) % knots.length,
              ind2 = (pos + length - i - 1) % knots.length,
              temp = knots[ind1];

        knots[ind1] = knots[ind2];
        knots[ind2] = temp;
    }
}

function getCharCodes(s){
    // Just taken from online... There must be a function to just get the ascii value of a char???
    let charCodeArr = [];

    for(let i = 0; i < s.length; i++){
        let code = s.charCodeAt(i);
        charCodeArr.push(code);
    }

    return charCodeArr;
}


function part1(lengths) {
    const nbrKnots = 256;
    let knots = Array.from(Array(nbrKnots).keys());

    pinchAndTwists(lengths, knots, 0, 0);
    console.log(`Simple hash ${knots[0] * knots[1]}`);
}

function getHashes(knots, size) {
    let hashes = [];

    // Would be interesting to do this concurrently
    for (let i = 0; i < knots.length; i += size) {
        let xor = knots[i];
        for (let j = 1; j < size; j++) {
            xor = xor ^ knots[i+j];
        }
        hashes.push(xor);
    }

    return hashes;
}

function part2(lengths) {

    lengths = lengths.concat([17, 31, 73, 47, 23]);

    const nbrKnots = 256,
          rounds = 64;
    let knots = Array.from(Array(nbrKnots).keys());

    let pos = 0,
        skip = 0;

    for (let i = 0; i < rounds; i++) {
        [pos, skip] = pinchAndTwists(lengths, knots, pos, skip);
    }

    const denseHash = getHashes(knots, 16);

    const knotHash = denseHash.map(x => {
            const num = x.toString(16);
            if (num.length == 1) {
                return "0".concat(num);
            } else {
                return num;
            }})
            .join('');

    console.log(`Knot hash ${knotHash}`);
}

main();