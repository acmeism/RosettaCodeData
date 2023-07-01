import "io" for Stdin, Stdout

var string
while (true) {
    System.write("Enter a string : ")
    Stdout.flush()
    string = Stdin.readLine()
    if (string.count == 0) {
        System.print("String cannot be empty, try again.")
    } else {
        break
    }
}

var number
while (true) {
    System.write("Enter a number : ")
    Stdout.flush()
    number = Num.fromString(Stdin.readLine())
    if (!number || !number.isInteger) {
        System.print("Please enter a vaid integer, try again.")
    } else {
        break
    }
}

System.print("\nYou entered:")
System.print("  string: %(string)")
System.print("  number: %(number)")
