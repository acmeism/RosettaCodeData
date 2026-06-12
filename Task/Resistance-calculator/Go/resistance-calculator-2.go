package main

import (
    "fmt"
    "strconv"
    "strings"
)

type Stack []*Resistor

func (s *Stack) push(r *Resistor) {
    *s = append(*s, r)
}

func (s *Stack) pop() *Resistor {
    le := len(*s)
    if le == 0 {
        panic("Attempt to pop from an empty stack")
    }
    le--
    r := (*s)[le]
    *s = (*s)[:le]
    return r
}

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

func build(rpn string) *Resistor {
    st := new(Stack)
    for _, token := range strings.Fields(rpn) {
        switch token {
        case "+":
            b, a := st.pop(), st.pop()
            st.push(&Resistor{'+', 0, 0, a, b})
        case "*":
            b, a := st.pop(), st.pop()
            st.push(&Resistor{'*', 0, 0, a, b})
        default:
            r, _ := strconv.ParseFloat(token, 64)
            st.push(&Resistor{'r', r, 0, nil, nil})
        }
    }
    return st.pop()
}

func main() {
    node := build("10 2 + 6 * 8 + 6 * 4 + 8 * 4 + 8 * 6 +")
    node.setVoltage(18)
    fmt.Println("     Ohm     Volt   Ampere     Watt  Network tree")
    node.report("")
}
