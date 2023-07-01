package singlep

// package level data declarations serve as singleton instance variables
var X, Y int

// package level initialization can serve as constructor code
func init() {
    X, Y = 2, 3
}

// package level functions serve as methods for a package-as-a-singleton
func F() int {
    return Y - X
}
