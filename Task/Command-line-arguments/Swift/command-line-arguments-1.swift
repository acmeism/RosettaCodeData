let args = Process.arguments
println("This program is named \(args[0]).")
println("There are \(args.count-1) arguments.")
for i in 1..<args.count {
  println("the argument #\(i) is \(args[i])")
}
