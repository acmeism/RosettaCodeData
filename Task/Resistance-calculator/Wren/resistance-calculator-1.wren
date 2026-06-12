import "./fmt" for Fmt

class Resistor {
    construct new(symbol, resistance, voltage, a, b) {
        _symbol = symbol
        _resistance = resistance
        _voltage = voltage
        _a = a
        _b = b
    }

    symbol { _symbol }
    resistance { _resistance }
    voltage { _voltage}

    res {
        if (_symbol == "+") return _a.res + _b.res
        if (_symbol == "*") return 1 / (1/_a.res + 1/_b.res)
        return _resistance
    }

    current { _voltage / res }

    effect { current * _voltage }

    voltage=(v) {
        if (_symbol == "+") {
            var ra = _a.res
            var rb = _b.res
            _a.voltage = ra / (ra + rb) * v
            _b.voltage = rb / (ra + rb) * v
        } else if (_symbol == "*") {
            _a.voltage = v
            _b.voltage = v
        }
        _voltage = v
    }

    report(level) {
        Fmt.lprint("$8.3f $8.3f $8.3f $8.3f  $s$s", [res, _voltage, current, effect, level, symbol])
        if (_a != null) _a.report(level + "| ")
        if (_b != null) _b.report(level + "| ")
    }

    +(other) { Resistor.new("+", 0, 0, this, other) }
    *(other) { Resistor.new("*", 0, 0, this, other) }
}

var r = List.filled(10, null)
var resistances = [6, 8, 4, 8, 4, 6, 8, 10, 6, 2]
for (i in 0..9) r[i] = Resistor.new("r", resistances[i], 0, null, null)
var node = ((((r[7]+r[9])*r[8]+r[6])*r[5]+r[4])*r[3]+r[2])*r[1] + r[0]
node.voltage = 18
System.print("     Ohm     Volt   Ampere     Watt  Network tree")
node.report("")
