"use strict"; // Can be omitted when using classes and modules as they enable it

function main() {

    let readline = require('readline');
    let parser = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
        terminal: false
    });

    // This way we can read multiple lines if we want
    // However, there must be a cleaner way to do this... Want to return and wait for futures
    let lengths;
    parser.on('line', function(line){
        lengths = line .split(',')
                    .map(Number);
                    parser.close();
    })

    parser.on('close', function() {
        pinchAndTwists(lengths, 256);
    })
}

function pinchAndTwists(lengths, nbrKnots) {
    let knots = Array.from(Array(nbrKnots).keys()),
        pos = 0,
        skip = 0;

    lengths.forEach((length) => {
        twist(pos, length, knots);

        pos = (pos + skip++ + length) % nbrKnots;
    })

    console.log(knots[0] * knots[1]);
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


main();