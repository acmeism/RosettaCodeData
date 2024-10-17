// version 1.1.2

fun subleq(program: String) {
    val words = program.split(' ').map { it.toInt() }.toTypedArray()
    val sb = StringBuilder()
    var ip = 0
    while (true) {
        val a = words[ip]
        val b = words[ip + 1]
        var c = words[ip + 2]
        ip += 3
        if (a < 0) {
            print("Enter a character : ")
            words[b] = readLine()!![0].toInt()
        }
        else if (b < 0) {
            sb.append(words[a].toChar())
        }
        else {
            words[b] -= words[a]
            if (words[b] <= 0) ip = c
            if (ip < 0) break
        }
    }
    print(sb)
}

fun main(args: Array<String>) {
    val program = "15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1 72 101 108 108 111 44 32 119 111 114 108 100 33 10 0"
    subleq(program)
}
