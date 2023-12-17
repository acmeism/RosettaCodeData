import "./dynamic" for Struct
import "./sort" for Sort
import "./fmt" for Fmt

var Wheel = Struct.create("Wheel", ["next", "values"])

var generate = Fn.new { |wheels, start, maxCount|
    var count = 0
    var w = wheels[start]
    while (true) {
        var s = w.values[w.next]
        var v = Num.fromString(s)
        w.next = (w.next + 1) % w.values.count
        wheels[start] = w
        if (v) {
            System.write("%(v) ")
            count = count + 1
            if (count == maxCount) {
                System.print("...\n")
                return
            }
        } else {
            while (true) {
                var w2 = wheels[s]
                var ss = s
                s = w2.values[w2.next]
                w2.next = (w2.next + 1) % w2.values.count
                wheels[ss] = w2
                v = Num.fromString(s)
                if (v) {
                    System.write("%(v) ")
                    count = count + 1
                    if (count == maxCount) {
                        System.print("...\n")
                        return
                    }
                    break
                }
            }
        }
    }
}

var printWheels = Fn.new { |wheels|
    var names = []
    for (name in wheels.keys) names.add(name)
    Sort.quick(names)
    System.print("Intersecting Number Wheel group:")
    for (name in names) {
        Fmt.print("  $s: $n", name, wheels[name].values)
    }
    System.write("  Generates:\n    ")
}

var wheelMaps = [
    {
        "A": Wheel.new(0, ["1", "2", "3"])
    },
    {
        "A": Wheel.new(0, ["1", "B", "2"]),
        "B": Wheel.new(0, ["3", "4"])
    },
    {
        "A": Wheel.new(0, ["1", "D", "D"]),
        "D": Wheel.new(0, ["6", "7", "8"])
    },
    {
        "A": Wheel.new(0, ["1", "B", "C"]),
        "B": Wheel.new(0, ["3", "4"]),
        "C": Wheel.new(0, ["5", "B"])
    }
]
for (wheels in wheelMaps) {
    printWheels.call(wheels)
    generate.call(wheels, "A", 20)
}
