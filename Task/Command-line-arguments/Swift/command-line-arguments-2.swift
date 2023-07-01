println("This program is named \(String.fromCString(Process.unsafeArgv[0])!).")
println("There are \(Process.argc-1) arguments.")
for i in 1 ..< Int(Process.argc) {
  println("the argument #\(i) is \(String.fromCString(Process.unsafeArgv[i])!)")
}
