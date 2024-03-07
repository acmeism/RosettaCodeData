import "./fmt" for Fmt

class Mwriter {
    construct new(value, log) {
        _value = value
        _log = log
    }

    value { _value }
    log {_log}
    log=(value) { _log = value }

    bind(f) {
        var n = f.call(_value)
        n.log = _log + n.log
        return n
    }

    static unit(v, s) { Mwriter.new(v, "  %(Fmt.s(-17, s)): %(v)\n") }
}

var root   = Fn.new { |v| Mwriter.unit(v.sqrt, "Took square root") }
var addOne = Fn.new { |v| Mwriter.unit(v + 1,  "Added one") }
var half   = Fn.new { |v| Mwriter.unit( v / 2, "Divided by two") }

var mw1 = Mwriter.unit(5, "Initial value")
var mw2 = mw1.bind(root).bind(addOne).bind(half)
System.print("The Golden Ratio is %(mw2.value)")
System.print("\nThis was derived as follows:-")
System.print(mw2.log)
