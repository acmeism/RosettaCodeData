import "io" for Stdin, Stdout

class Test {
    construct new() {}

    foo() { System.print("Foo called.") }

    bar() { System.print("Bar called.") }

    missingMethod(m) {
        System.print(m)
        System.write("Try and continue anyway y/n ? ")
        Stdout.flush()
        var reply = Stdin.readLine()
        if (reply != "y" && reply != "Y") {
            Fiber.abort("Decided to abort due to missing method.")
        }
    }
}

var test = Test.new()
var f = Fiber.new {
    test.foo()
    test.bar()
    test.baz()
}
f.try()
var err = f.error
if (err) {
    if (err.startsWith("Test does not implement")) {
        test.missingMethod(err)
    } else {
        Fiber.abort(err) // rethrow other errors
    }
}
System.print("OK, continuing.")
