import "./dynamic" for Enum

var MultitonType = Enum.create("MultitonType", ["zero", "one", "two"])

class Multiton {
    // private constructor
    construct new_(type) {
        _type = type
    }

    static getInstance(type) {
        if (!(0...MultitonType.members.count).contains(type)) {
            Fiber.abort("Invalid MultitonType member.")
        }
        if (!__instances) __instances = {}
        if (!__instances.containsKey(type)) __instances[type] = new_(type)
        return __instances[type]
    }

    type { _type }

    toString { MultitonType.members[_type] }
}

var m0 = Multiton.getInstance(MultitonType.zero)
var m1 = Multiton.getInstance(MultitonType.one)
var m2 = Multiton.getInstance(MultitonType.two)

System.print(m0)
System.print(m1)
System.print(m2)

var m3 = Multiton.getInstance(3)  // produces an error
