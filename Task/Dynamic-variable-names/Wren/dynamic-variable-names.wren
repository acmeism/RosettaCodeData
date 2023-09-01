import "./ioutil" for Input
import "./trait" for Var

System.print("Enter three variables:")
for (i in 0..2) {
    var name  = Input.text("\n  name  : ")
    var value = Input.text("  value : ")
    Var[name] = Num.fromString(value)
}

System.print("\nYour variables are:\n")
for (kv in Var.entries) {
    System.print("  %(kv.key) = %(kv.value)")
}
