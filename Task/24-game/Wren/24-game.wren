import "random" for Random
import "/ioutil" for Input
import "/seq" for Stack

var R = Random.new()

class Game24 {
    static run() {
        var digits = List.filled(4, 0)
        for (i in 0..3) digits[i] = R.int(1, 10)
        System.print("Make 24 using these digits: %(digits)")
        var cin = Input.text("> ")
        var s = Stack.new()
        var total = 0
        for (c in cin) {
            var d = c.bytes[0]
            if (d >= 48 && d <= 57) {
                d = d - 48
                total = total + (1 << (d*5))
                s.push(d)
            } else if ("+-*/".indexOf(c) != -1) s.push(applyOperator_(s.pop(), s.pop(), c))
        }
        if (tallyDigits_(digits) != total) {
            System.write("Not the same digits.")
        } else if ((24 - s.peek()).abs < 0.001) {
            System.print("Correct!")
        } else {
            System.write("Not correct.")
        }
    }

    static applyOperator_(a, b, c) {
        if (c == "+") return a + b
        if (c == "-") return b - a
        if (c == "*") return a * b
        if (c == "/") return b / a
        return 0/0
    }

    static tallyDigits_(a) {
        var total = 0
        for (i in 0...a.count) total = total + (1 << (a[i]*5))
        return total
    }
}

Game24.run()
