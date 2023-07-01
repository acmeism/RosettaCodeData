// Boolean Value, in V
// Tectonics: v run boolean-value.v
module main

// V bool type, with values true or false are the V booleans.
// true and false are V keywords, and display as true/false
// Numeric values are not booleans in V, 0 is not boolean false
pub fn main() {
    t := true
    f := false

    if t { println(t) }

    // this code would fail to compile
    // if 1 { println(t) }

    if 0 == 1 { println("bad result") } else { println(f) }
}
