interface Foo guards FooStamp {
    to bar(a :int, b :int)
}

def x implements FooStamp {
    to bar(a :int, b :int) {
        return a - b
    }
}
