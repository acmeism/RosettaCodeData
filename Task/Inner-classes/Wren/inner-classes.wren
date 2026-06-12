class Outer {
    static makeInner {
        class Inner is Outer {
            construct new(field) {
                super(field + 1) // call parent class constructor
                _field = field
            }

            method {
                System.print("Inner's field has a value of %(_field)")
                outerMethod
            }
        }
        return Inner
    }

    construct new(field) {
        _field = field
    }

    outerMethod {
        System.print("Outer's field has a value of %(_field)")
    }
}

var Inner = Outer.makeInner
var inner = Inner.new(42)
inner.method
