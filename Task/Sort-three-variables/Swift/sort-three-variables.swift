func varSort<T: Comparable>(_ x: inout T, _ y: inout T, _ z: inout T) {
  let res = [x, y, z].sorted()

  x = res[0]
  y = res[1]
  z = res[2]
}

var x = "lions, tigers, and"
var y = "bears, oh my!"
var z = "(from the \"Wizard of OZ\")"

print("Before:")
print("x = \(x)")
print("y = \(y)")
print("z = \(z)")
print()

varSort(&x, &y, &z)

print("After:")
print("x = \(x)")
print("y = \(y)")
print("z = \(z)")
