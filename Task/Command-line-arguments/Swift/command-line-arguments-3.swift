println("This program is named \(String.fromCString(C_ARGV[0])!).")
println("There are \(C_ARGC-1) arguments.")
for i in 1 ..< Int(C_ARGC) {
  println("the argument #\(i) is \(String.fromCString(C_ARGV[i])!)")
}
