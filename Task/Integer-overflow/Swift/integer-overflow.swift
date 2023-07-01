// By default, all overflows in Swift result in a runtime exception, which is always fatal
// However, you can opt-in to overflow behavior with the overflow operators and continue with wrong results

var int32:Int32
var int64:Int64
var uInt32:UInt32
var uInt64:UInt64

println("signed 32-bit int:")
int32 = -1 &* (-2147483647 - 1)
println(int32)
int32 = 2000000000 &+ 2000000000
println(int32)
int32 = -2147483647 &- 2147483647
println(int32)
int32 = 46341 &* 46341
println(int32)
int32 = (-2147483647-1) &/ -1
println(int32)
println()

println("signed 64-bit int:")
int64 = -1 &* (-9223372036854775807 - 1)
println(int64)
int64 = 5000000000000000000&+5000000000000000000
println(int64)
int64 = -9223372036854775807 &- 9223372036854775807
println(int64)
int64 = 3037000500 &* 3037000500
println(int64)
int64 = (-9223372036854775807-1) &/ -1
println(int64)
println()

println("unsigned 32-bit int:")
println("-4294967295 is caught as a compile time error")
uInt32 = 3000000000 &+ 3000000000
println(uInt32)
uInt32 = 2147483647 &- 4294967295
println(uInt32)
uInt32 = 65537 &* 65537
println(uInt32)
println()

println("unsigned 64-bit int:")
println("-18446744073709551615 is caught as a compile time error")
uInt64 = 10000000000000000000 &+ 10000000000000000000
println(uInt64)
uInt64 = 9223372036854775807 &- 18446744073709551615
println(uInt64)
uInt64 = 4294967296 &* 4294967296
println(uInt64)
