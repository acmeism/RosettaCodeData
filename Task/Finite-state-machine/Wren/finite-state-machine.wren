import "./str" for Str
import "io" for Stdin, Stdout

var READY     = 0
var WAITING   = 1
var EXIT      = 2
var DISPENSE  = 3
var REFUNDING = 4

var fsm = Fn.new {
    System.print("Please enter your option when prompted")
    System.print("(any characters after the first will be ignored)")
    var state = READY
    var trans = ""
    while (true) {
        if (state == READY) {
            while (true) {
                System.write("\n(D)ispense or (Q)uit : ")
                Stdout.flush()
                trans = Str.lower(Stdin.readLine())[0]
                if (trans == "d" || trans == "q") break
            }
            state = (trans == "d") ? WAITING : EXIT
        } else if (state == WAITING) {
            System.print("OK, put your money in the slot")
            while (true) {
                System.write("(S)elect product or choose a (R)efund : ")
                Stdout.flush()
                trans = Str.lower(Stdin.readLine())[0]
                if (trans == "s" || trans == "r") break
            }
            state = (trans == "s") ? DISPENSE : REFUNDING
        } else if (state == DISPENSE) {
            while (true) {
                System.write("(R)emove product : ")
                Stdout.flush()
                trans = Str.lower(Stdin.readLine())[0]
                if (trans == "r") break
            }
            state = READY
        } else if (state == REFUNDING) {
            // no transitions defined
            System.print("OK, refunding your money")
            state = READY
        } else if (state == EXIT) {
            System.print("OK, quitting")
            return
        }
    }
}

fsm.call()
