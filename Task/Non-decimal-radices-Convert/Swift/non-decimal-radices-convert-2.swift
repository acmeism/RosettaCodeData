import Darwin
func string2int(s: String, radix: Int) -> Int {
  return strtol(s, nil, Int32(radix))
  // there is also strtoul() for UInt, and strtoll() and strtoull() for Int64 and UInt64, respectively
}
println(string2int("1a", 16)) // prints "26"
