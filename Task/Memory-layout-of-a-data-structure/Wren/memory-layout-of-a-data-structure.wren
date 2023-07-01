import "/seq" for Lst
import "/fmt" for Fmt

var ON  = true
var OFF = false

// Converts "ON"/"OFF" string to true/false.
var AsBool = Fn.new { |s| s == "ON" }

class RS232_9 {
    static names { ["CD", "RD", "TD", "DTR", "SG", "DSR", "RTS", "CTS", "RI"] }

    construct new() { _settings = [OFF] * 9 } // all pins OFF

    // get pin setting as an ON/OFF string by pin name or number; returns null if invalid
    [p] {
        if (p is String) {
            var ix = Lst.indexOf(RS232_9.names, p)
            return (ix >= 0 && ix < 9) ? (_settings[ix] ? "ON" : "OFF") : null
        }
        if (p is Num) {
            return (p.isInteger && p >= 1 && p <= 9) ? (_settings[p-1] ? "ON" : "OFF") : null
        }
        return null
    }

    // set pin by pin name or number; does nothing if invalid
    [p] = (v) {
        if (v.type == String && (v == "ON" || v == "OFF")) v = AsBool.call(v)
        if (v.type != Bool) return
        if (p is String) {
            var ix = Lst.indexOf(RS232_9.names, p)
            if (ix >= 0 && ix < 9) _settings[ix] = v
        }
        if (p is Num && p.isInteger && p >= 1 && p <= 9) _settings[p-1] = v
    }

    // prints all pin settings
    toString { (1..9).map { |i| "%(i) %(Fmt.s(-3, RS232_9.names[i-1])) = %(this[i])" }.join("\n") }
}

var plug = RS232_9.new()
plug["CD"]  = ON      // set pin 1 by name
plug[3]     = ON      // set pin 3 by number
plug["DSR"] = "ON"    // set pin 6 by name and using a string
System.print(plug)    // print the state of the pins
