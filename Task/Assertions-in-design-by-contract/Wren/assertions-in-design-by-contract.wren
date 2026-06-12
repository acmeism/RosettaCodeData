import "./assert" for Assert
import "./math" for Nums

// Assert.disabled = true

var averageOfAbsolutes = Fn.new { |values|
    // pre-condition
    Assert.ok(values.count > 0, "Values list must be non-empty.")

    var result = Nums.mean(values.map { |v| v.abs })
    // post-condition
    Assert.ok(result >= 0, "Average of absolute values should be non-negative.")
    return result
}

class Foo {
    construct new(x) {
        _x = x
        checkInvariant_()
    }

    x { _x }
    x=(v) {
        _x = v
        checkInvariant_()
    }

    inc {
        // no need to check invariance here
        _x = _x + 1
    }

    checkInvariant_() {
        Assert.ok(_x >= 0, "Field 'x' must be non-negative.")
    }
}

System.print(averageOfAbsolutes.call([1, 3]))
var f = Foo.new(-1)
f.inc
System.print(f.x)
