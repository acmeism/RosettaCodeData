var a           // declares the variable 'a' with the default value of 'null'
a = 1           // initializes 'a'
a = "a"         // assigns a different value to 'a'
var b = 2       // declares and initializes 'b' at the same time
b = true        // assigns a different value to 'b'
var c = [3, 4]  // 'c' is assigned a List which is a reference type
c = false       // 'c' is reassigned a Bool which is a value type

var d = 1       // declaration at top level
{
    var d = 2   // declaration within a nested scope, hides top level 'd'
    var e = 3   // not visible outside its scope i.e this block
}
System.print(d) // prints the value of the top level 'd'
System.print(e) // compiler error : Variable is used but not defined
