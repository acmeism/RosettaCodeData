package main

import "core:fmt"
import "core:math"

Compositor :: struct($ARG, $INTER, $RET: typeid) {
	func1: #type proc "contextless" (_: ARG) -> INTER,
	func2: #type proc "contextless" (_: INTER) -> RET,
}

compose :: proc(
	f: #type proc "contextless" (_: $INTER) -> $RET,
	g: #type proc "contextless" (_: $ARG) -> INTER,
) -> Compositor(ARG, RET, INTER) {
	return {g, f}
}

call :: proc(c: Compositor($ARG, $INTER, $RET), arg: ARG) -> RET {
	return c.func1(c.func2(arg))
}

main :: proc() {
	comp := compose(math.sin_f64, math.asin_f64) // have to use specific functions. Odin's polymorphism doesn't play nice with procedure groups
	fmt.println(call(comp, 0.5)) // prints 0.5
}
