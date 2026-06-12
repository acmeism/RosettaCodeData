package main

import "fmt"

type Resistor struct {
    symbol              rune
    resistance, voltage float64
    a, b                *Resistor
}

func (r *Resistor) res() float64 {
    switch r.symbol {
    case '+':
        return r.a.res() + r.b.res()
    case '*':
        return 1 / (1/r.a.res() + 1/r.b.res())
    default:
        return r.resistance
    }
}

func (r *Resistor) setVoltage(voltage float64) {
    switch r.symbol {
    case '+':
        ra := r.a.res()
        rb := r.b.res()
        r.a.setVoltage(ra / (ra + rb) * voltage)
        r.b.setVoltage(rb / (ra + rb) * voltage)
    case '*':
        r.a.setVoltage(voltage)
        r.b.setVoltage(voltage)
    }
    r.voltage = voltage
}

func (r *Resistor) current() float64 {
    return r.voltage / r.res()
}

func (r *Resistor) effect() float64 {
    return r.current() * r.voltage
}

func (r *Resistor) report(level string) {
    fmt.Printf("%8.3f %8.3f %8.3f %8.3f  %s%c\n", r.res(), r.voltage, r.current(), r.effect(), level, r.symbol)
    if r.a != nil {
        r.a.report(level + "| ")
    }
    if r.b != nil {
        r.b.report(level + "| ")
    }
}

func (r *Resistor) add(other *Resistor) *Resistor {
    return &Resistor{'+', 0, 0, r, other}
}

func (r *Resistor) mul(other *Resistor) *Resistor {
    return &Resistor{'*', 0, 0, r, other}
}

func main() {
    var r [10]*Resistor
    resistances := []float64{6, 8, 4, 8, 4, 6, 8, 10, 6, 2}
    for i := 0; i < 10; i++ {
        r[i] = &Resistor{'r', resistances[i], 0, nil, nil}
    }
    node := r[7].add(r[9]).mul(r[8]).add(r[6]).mul(r[5]).add(r[4]).mul(r[3]).add(r[2]).mul(r[1]).add(r[0])
    node.setVoltage(18)
    fmt.Println("     Ohm     Volt   Ampere     Watt  Network tree")
    node.report("")
}
