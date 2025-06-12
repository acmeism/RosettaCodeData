package runge_kutta

import "core:fmt"
import "core:math"

func :: proc(x: f32, y: f32) -> f32 {
    return x * math.sqrt(y)
}

main :: proc() {
    STEPS :: 100
    sols: [STEPS + 1]f32

    x0, y0, h := f32(0.0), f32(1.0), f32(0.1)
    xn, yn    := x0, y0

    sols[0] = y0
    factor := f32(1.0 / 6.0)

    for &sol in sols[1:] {
        dy1 := h * func(xn,yn)
        dy2 := h * func(xn + 0.5 * h, yn + 0.5 * dy1)
        dy3 := h * func(xn + 0.5 * h, yn + 0.5 * dy2)
        dy4 := h * func(xn +       h, yn +       dy3)
        sol = yn + factor * (dy1 + 2 * dy2 + 2 * dy3 + dy4)
        yn  = sol
        xn  = xn + h
    }

    for i in 1..<STEPS {
        if i % 10 == 0 {
            exact := (1.0 / 16.0) * math.pow((math.pow(f32(i / 10), 2) + 4), 2)
            error := sols[i] - (1.0 / 16.0) * math.pow((math.pow(f32(i / 10), 2) + 4), 2)
            fmt.printfln("%.9f\texact: %.4f\terror: %v", sols[i], exact, error)
        }
    }
}
