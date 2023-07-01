import Foundation

// All variables declared outside of a struct/class/etc are global

// Swift is a typed language
// Swift can infer the type of variables
var str = "Hello, playground" // String
let letStr:String = "This is a constant"

// However, all variables must be initialized
// Intialize variable of type String to nil
var str1:String! // str1 is nil

// Assign value to str1
str1 = "foo bar" // str1 is foo bar

// Swift also has optional types
// Declare optional with type of String
var optionalString = Optional<String>("foo bar") // (Some "foo bar")

println(optionalString) // Optional("foo bar")

// Optionals can also be declared with the shorthand ?
var optionalString1:String? = "foo bar"

// ! can be used to force unwrap but will throw a runtime error if trying to unwrap a nil value
println(optionalString1!)

optionalString1 = nil // Is now nil
// println(optionalString1!) would now throw a runtime error

// Optional chaining can be used to gracefully fail if there is a nil value
if let value = optionalString1?.lowercaseString {
    // Is never executed
} else {
    println("optionalString1 is nil")
}

// Swift also has type aliasing
typealias MyNewType = String // MyNewType is an alias of String
var myNewTypeString = MyNewType("foo bar")

// Swift also has special types Any and AnyObject
// Any can hold any type
// AnyObject can hold any object type
let myAnyObjectString:AnyObject = "foo bar"

// Downcast myAnyObjectString to String
if let myString = myAnyObjectString as? String {
    println(myString) // foo bar
} else {
    println("myString is not a string")
}

// Swift treats functions as first-class
// Declare a variable with a type of a function that takes no args
// and returns Void
var myFunc:(() -> Void)
func showScopes() {
    // Variable is scoped to function
    let myFunctionVariable = "foo bar function"

    // Nested functions inherit variables declared in enclosing scope
    func nestFunc() {
        println(myFunctionVariable)
    }
    nestFunc()
}

myFunc = showScopes // myFunc is now showScopes
myFunc() // foo bar function
