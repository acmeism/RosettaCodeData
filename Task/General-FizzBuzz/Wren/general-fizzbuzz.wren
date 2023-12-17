import "io" for Stdin, Stdout
import "./sort" for Sort

var n

while (true) {
    System.write("Maximum number : ")
    Stdout.flush()
    n = Num.fromString(Stdin.readLine())
    if (!n || !n.isInteger || n < 3) {
        System.print("Must be an integer > 2, try again.")
    } else {
        break
    }
}

var factors = []
var words = {}
for (i in 0..2) {
    while (true) {
        System.write("Factor %(i+1) : ")
        Stdout.flush()
        var factor = Num.fromString(Stdin.readLine())
        if (!factor || !factor.isInteger || factor < 2 || factors.contains(factor)) {
            System.print("Must be an unused integer > 1, try again.")
        } else {
            factors.add(factor)
            var outer = false
            while (true) {
                System.write("  Word %(i+1) : ")
                Stdout.flush()
                var word = Stdin.readLine()
                if (word.count == 0) {
                    System.print("Must have at least one character, try again.")
                } else {
                    words[factor] = word
                    outer = true
                    break
                }
            }
            if (outer) break
        }
    }
}

Sort.insertion(factors)
System.print()
for (i in 1..n) {
    var s = ""
    for (j in 0..2) {
        var factor = factors[j]
        if (i % factor == 0) s = s + words[factor]
    }
    if (s == "") s = i.toString
    System.print(s)
}
