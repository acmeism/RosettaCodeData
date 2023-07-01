import "./fmt" for Fmt

var ops = [ "5**3**2", "(5**3)**2", "5**(3**2)" ]
var results = [ 5.pow(3).pow(2), (5.pow(3)).pow(2), 5.pow(3.pow(2)) ]
for (i in 0...ops.count) {
    Fmt.print("$-9s -> $d", ops[i], results[i])
}
