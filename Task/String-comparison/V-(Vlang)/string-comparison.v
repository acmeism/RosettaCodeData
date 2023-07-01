fn main() {
    c := "cat"
    d := "dog"
    if c == d {
        println('$c is bytewise identical to $d')
    }
    if c != d {
        println('$c is bytewise different from $d')
    }
    if c > d {
        println('$c is lexically bytewise greater than $d')
    }
    if c < d {
        println('$c is lexically bytewise less than $d')
    }
    if c >= d {
        println('$c is lexically bytewise greater than or equal to $d')
    }
    if c <= d {
        println('$c is lexically bytewise less than or equal to $d')
    }
}
