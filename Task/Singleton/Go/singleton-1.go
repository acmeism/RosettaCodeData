package singlep

// package level data declarations serve as singleton instance variables
var X, Y int

// package level functions serve as methods for a package-as-a-singleton
func F() int {
    return Y - X
}
