import "io" for Stdin, Stdout

System.write("Do you want to terminate the program y/n ?  ")
Stdout.flush()
var yn = Stdin.readLine()
if (yn == "y" || yn == "Y") {
    System.print("OK, shutting down")
    Fiber.suspend() // return to OS
}
System.print("OK, carrying on")
