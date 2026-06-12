/* logAspectAdder.wren */

import "./adder" for Adder

var Start = System.clock // initialize timer for logging

class LogAspectAdder {
    static log(s) {
        var elapsed = ((System.clock - Start) * 1e6).round
        System.print("After %(elapsed) μs : %(s)")
    }

    static add2(x) {
        log("added 2 to %(x)")
        return Adder.add2(x)
    }
}
