import "./crypto" for Sha256, Ripemd160
import "./str" for Str
import "./fmt" for Conv

// converts an hexadecimal string to a byte list.
var HexToBytes = Fn.new { |s| Str.chunks(s, 2).map { |c| Conv.atoi(c, 16) }.toList }

// Point is a class for a bitcoin public point
class Point {
    construct new() {
        _x = List.filled(32, 0)
        _y = List.filled(32, 0)
    }

    x { _x }
    y { _y }

    // setHex takes two hexadecimal strings and decodes them into the receiver.
    setHex(s, t) {
        if (s.count != 64 || t.count != 64) Fiber.abort("Invalid hex string length.")
        _x = HexToBytes.call(s)
        _y = HexToBytes.call(t)
    }
}

// Represents a bitcoin address.
class Address {
    static tmpl_ { "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".bytes }

    construct new() {
        _a = List.filled(25, 0)
    }

    a { _a }

    // returns a base58 encoded bitcoin address corresponding to the receiver.
    a58 {
        var out = List.filled(34, 0)
        for (n in 33..0) {
            var c = 0
            for (i in 0..24) {
                c = c * 256 + _a[i]
                _a[i] = (c/58).floor
                c = c % 58
            }
            out[n] = Address.tmpl_[c]
        }
        var i = 1
        while (i < 34 && out[i] == 49) i = i + 1
        return out[i-1..-1]
    }

    // doubleSHA256 computes a double sha256 hash of the first 21 bytes of the
    // address, returning the full 32 byte sha256 hash.
    doubleSHA256() {
        var d = Sha256.digest(_a[0..20])
        d = HexToBytes.call(d)
        d = Sha256.digest(d)
        return HexToBytes.call(d)
    }

    // updateChecksum computes the address checksum on the first 21 bytes and
    // stores the result in the last 4 bytes.
    updateCheckSum() {
        var d = doubleSHA256()
        for (i in 21..24) _a[i] = d[i-21]
    }

    // setPoint takes a public point and generates the corresponding address
    // into the receiver, complete with valid checksum.
    setPoint(p) {
        var c = List.filled(65, 0)
        c[0] = 4
        for (i in 1..32)  c[i] = p.x[i - 1]
        for (i in 33..64) c[i] = p.y[i - 33]
        var s = Sha256.digest(c)
        s = HexToBytes.call(s)
        var h = Ripemd160.digest(s)
        h = HexToBytes.call(h)
        for (i in 0...h.count) _a[i+1] = h[i]
        updateCheckSum()
    }
}

// parse hex into Point object
var p = Point.new()
p.setHex(
    "50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352",
    "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6"
)
// generate Address object from Point
var a = Address.new()
a.setPoint(p)
// show base58 representation
System.print(a.a58.map { |b| String.fromByte(b) }.join())
