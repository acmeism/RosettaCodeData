import "io" for Stdin, Stdout

while (true) {
    System.write("Enter two integers separated by a space : ")
    Stdout.flush()
    var s = Stdin.readLine().split(" ")
    if (s.count < 2) {
        System.print("Insufficient numbers, try again")
    } else {
        var a = Num.fromString(s[0])
        var b = Num.fromString(s[s.count-1])
        System.print("Their sum is %(a + b)")
        return
    }
}
