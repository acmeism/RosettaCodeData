import "io" for Stdin, Stdout

var userVars = {}
System.print("Enter three variables:")
for (i in 0..2) {
    System.write("\n  name : ")
    Stdout.flush()
    var name = Stdin.readLine()
    System.write("  value: ")
    Stdout.flush()
    var value = Num.fromString(Stdin.readLine())
    userVars[name] = value
}

System.print("\nYour variables are:\n")
for (kv in userVars) {
    System.print("  %(kv.key) = %(kv.value)")
}
