// version 1.1.0

class Hanoi(disks: Int) {
    private var moves = 0

    init {
        println("Towers of Hanoi with $disks disks:\n")
        move(disks, 'L', 'C', 'R')
        println("\nCompleted in $moves moves\n")
    }

    private fun move(n: Int, from: Char, to: Char, via: Char) {
        if (n > 0) {
            move(n - 1, from, via, to)
            moves++
            println("Move disk $n from $from to $to")
            move(n - 1, via, to, from)
        }
    }
}

fun main(args: Array<String>) {
    Hanoi(3)
    Hanoi(4)
}
