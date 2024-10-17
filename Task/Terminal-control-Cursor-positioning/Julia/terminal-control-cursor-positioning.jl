const ESC = "\u001B"

gotoANSI(x, y) = print("$ESC[$(y);$(x)H")

gotoANSI(3, 6)
println("Hello")
