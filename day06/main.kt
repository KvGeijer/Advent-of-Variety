package day06

import java.util.Scanner


fun parse(): ArrayList<Int> {
    val scanner = Scanner(System.`in`)
    val array = ArrayList<Int>()

    while(scanner.hasNext()) {
        array.add(scanner.nextInt())
    }

    return array
}


fun redistribute( blocks: ArrayList<Int>) {
    val max = blocks.maxOrNull() ?: 0
    
    var index = blocks.indexOf(max)

    blocks.set(index, 0);

    for (bank in max downTo 1 step 1) {
        if (++index >= blocks.size) {
            index = 0;
        }

        blocks.set(index, blocks.get(index) + 1)
    }

}


fun part1( blocks: ArrayList<Int>): Unit {
    val observed = HashSet<ArrayList<Int>>()
    var size = 0

    do {


        observed.add(ArrayList<Int>(blocks))
        redistribute(blocks)
        size++

    } while (!observed.contains(blocks))

    println("Iterations before duplicate: " + size)

}


fun main() {
    val blocks = parse()

    part1(blocks)
}

