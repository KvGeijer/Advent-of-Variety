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


fun simulate( blocks: ArrayList<Int>): Pair<Int, Int> {
    val observed = HashMap<ArrayList<Int>, Int>()
    var size = 0

    do {

        
        observed.set(ArrayList<Int>(blocks), size)
        redistribute(blocks)
        size++

    } while (!observed.contains(blocks))

    return Pair(size, size - (observed.get(blocks) ?: 0))

}


fun main() {
    val blocks = parse()

    val (size, loop_size) = simulate(blocks)

    println("Iterations before duplicate: " + size)
    println("Size of each loop: " + loop_size)

}

