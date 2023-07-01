// version 1.1.2

fun isAscending(a: IntArray): Boolean {
    for (i in 0..8) if (a[i] != i + 1) return false
    return true
}

fun main(args: Array<String>) {
    val r = java.util.Random()
    var count = 0
    val numbers = IntArray(9)
    numbers[0] = 2 + r.nextInt(8) // this will ensure list isn't ascending
    for (i in 1..8) {
        var rn: Int
        do {
            rn = 1 + r.nextInt(9)
        } while (rn in numbers)
        numbers[i] = rn
    }
    println("Here's your first list : ${numbers.joinToString()}")
    while (true) {
        var rev: Int
        do {
            print("How many numbers from the left are to be reversed : ")
            rev = readLine()!!.toInt()
        } while (rev !in 2..9)
        count++
        var i = 0
        var j = rev - 1
        while (i < j) {
            val temp = numbers[i]
            numbers[i++] = numbers[j]
            numbers[j--] = temp
        }
        if (isAscending(numbers)) {
            println("Here's your final list : ${numbers.joinToString()}")
            break
        }
        println("Here's your list now   : ${numbers.joinToString()}")
    }
    println("So you've completed the game with a score of $count")
}
