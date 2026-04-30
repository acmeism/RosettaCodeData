struct Point {
    mut:
    x f64
    y f64
}

struct Circle {
    mut:
    x f64
    y f64
    r f64
}

// interface definition
interface Printer {
    print()
}

// point methods
fn (p &Point) print() {
    println('$p.x $p.y')
}

fn (p &Point) get_x() f64 {
    return p.x
}

fn (mut p Point) set_x(v f64) {
    p.x = v
}

fn (p &Point) get_y() f64 {
    return p.y
}

fn (mut p Point) set_y(v f64) {
    p.y = v
}

fn (p &Point) clone() &Point {
    return &Point{
        x: p.x
        y: p.y
    }
}

fn (mut p Point) set(q &Point) {
    p.x = q.x
    p.y = q.y
}

// circle methods
fn (c &Circle) print() {
    println('$c.x $c.y $c.r')
}

fn (c &Circle) get_x() f64 {
    return c.x
}

fn (mut c Circle) set_x(v f64) {
    c.x = v
}

fn (c &Circle) get_y() f64 {
    return c.y
}

fn (mut c Circle) set_y(v f64) {
    c.y = v
}

fn (c &Circle) get_r() f64 {
    return c.r
}

fn (mut c Circle) set_r(v f64) {
    c.r = v
}

fn (c &Circle) clone() &Circle {
    return &Circle{
        x: c.x
        y: c.y
        r: c.r
    }
}

fn (mut c Circle) set(d &Circle) {
    c.x = d.x
    c.y = d.y
    c.r = d.r
}

// "constructors" are idiomatic if involving something more than just assigning initial values
// in V, by default, structs have default values relative to their type
fn new_point(x f64, y f64) &Point {
    return &Point{
        x: x
        y: y
    }
}

fn new_circle(x f64, y f64, r f64) &Circle {
    return &Circle{
        x: x
        y: y
        r: r
    }
}

// a type of polymorphism: both types implement the printer interface
// print function can be called through a variable without knowing the underlying type
fn main() {
    mut i := Printer(new_point(3, 4)) // polymorphic variable + assign one type
    i.print() // call polymorphic function
    i = Printer(new_circle(5, 12, 13)) // assign different type to same variable
    i.print() // same call accesses different method now
}
