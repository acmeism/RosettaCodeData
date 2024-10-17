// version 1.1.2

fun main(args: Array<String>) {
    var coconuts = 11
    outer@ for (ns in 2..9) {
        val hidden = IntArray(ns)
        coconuts = (coconuts / ns) * ns + 1
        while (true) {
            var nc = coconuts
            for (s in 1..ns) {
                if (nc % ns == 1) {
                    hidden[s - 1] = nc / ns
                    nc -= hidden[s - 1] + 1
                    if (s == ns && nc % ns == 0) {
                        println("$ns sailors require a minimum of $coconuts coconuts")
                        for (t in 1..ns) println("\tSailor $t hides ${hidden[t - 1]}")
                        println("\tThe monkey gets $ns")
                        println("\tFinally, each sailor takes ${nc / ns}\n")
                        continue@outer
                    }
                }
                else break
            }
            coconuts += ns
        }
    }
}
