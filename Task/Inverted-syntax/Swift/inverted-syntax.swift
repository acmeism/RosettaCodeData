infix operator ~= {}
infix operator ! {}

func ~=(lhs:Int, inout rhs:Int) {
    rhs = lhs
}

func !(lhs:(() -> Void), rhs:Bool) {
    if (rhs) {
        lhs()
    }
}

// Traditional assignment
var a = 0

// Inverted using a custom operator
20 ~= a

let raining = true
let tornado = true
var needUmbrella = false
var stayInside = false

// Traditional conditional expression
if raining {needUmbrella = true}

// Inverted using a custom operator
_ = {stayInside = true} ! tornado
