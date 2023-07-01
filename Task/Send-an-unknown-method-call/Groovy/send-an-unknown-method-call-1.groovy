class Example {
    def foo(value) {
        "Invoked with '$value'"
    }
}

def example = new Example()
def method = "foo"
def arg = "test value"

assert "Invoked with 'test value'" == example."$method"(arg)
