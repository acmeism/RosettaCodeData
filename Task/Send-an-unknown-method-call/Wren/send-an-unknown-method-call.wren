import "meta" for Meta

class Test {
    construct new() {}

    foo() { System.print("Foo called.") }

    bar() { System.print("Bar called.") }
}

var test = Test.new()
for (method in ["foo", "bar"]) {
    Meta.eval("test.%(method)()")
}
