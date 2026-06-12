// version 1.1.51

enum class State { READY, WAITING, EXIT, DISPENSE, REFUNDING }

fun fsm() {
    println("Please enter your option when prompted")
    println("(any characters after the first will be ignored)")
    var state = State.READY
    var trans: String

    while (true) {
        when (state) {
            State.READY -> {
                do {
                    print("\n(D)ispense or (Q)uit : ")
                    trans = readLine()!!.lowercase().take(1)
                }
                while (trans != "d" && trans != "q")
                state = if (trans == "d") State.WAITING else State.EXIT
            }

            State.WAITING -> {
                println("OK, put your money in the slot")
                do {
                    print("(S)elect product or choose a (R)efund : ")
                    trans = readLine()!!.lowercase().take(1)
                }
                while (trans != "s" && trans != "r")
                state = if (trans == "s") State.DISPENSE else State.REFUNDING
            }

            State.DISPENSE -> {
                do {
                    print("(R)emove product : ")
                    trans = readLine()!!.lowercase().take(1)
                }
                while (trans != "r")
                state = State.READY
            }

            State.REFUNDING -> {
                // no transitions defined
                println("OK, refunding your money")
                state = State.READY
            }

            State.EXIT -> {
                println("OK, quitting")
                return
            }
        }
    }
}

fun main(args: Array<String>) {
    fsm()
}
