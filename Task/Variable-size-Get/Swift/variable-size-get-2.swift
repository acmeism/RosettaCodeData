// sizeof and sizeofValue return the size in bytes.
println(sizeof(Int))
var i: Int = 42
println(sizeofValue(i))
// The size returned is that of the top level value and does not
// include any referenced data.  A type like String always returns
// the same number, the size of the String struct.
println(sizeofValue("Rosetta"))
println(sizeofValue("Code"))}
