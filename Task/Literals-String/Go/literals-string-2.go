ch := 'z'          // by default, ch takes type int32
var r rune = 'z'   // reflect.TypeOf(r) still returns int32
var b byte = 'z'   // reflect.TypeOf(b) returns uint8
b2 := byte('z')    // equivalent to b
const c byte = 'z' // c is now a "typed constant"
b3 := c            // equivalent to b
