import "./str" for Str

var compareStrings = Fn.new { |a, b, sens|
    System.write("Comparing '%(a)' and '%(b)', ")
    var c
    var d
    if (sens) {
        System.print("case sensitively:")
        c = a
        d = b
    } else {
        System.print("case insensitively:")
        c = Str.lower(a)
        d = Str.lower(b)
    }
    System.print("     %(a) <  %(b) -> %(Str.lt(c, d))")
    System.print("     %(a) >  %(b) -> %(Str.gt(c, d))")
    System.print("     %(a) == %(b) -> %(c == d)")
    System.print("     %(a) != %(b) -> %(c != d)")
    System.print("     %(a) <= %(b) -> %(Str.le(c, d))")
    System.print("     %(a) >= %(b) -> %(Str.ge(c, d))")
    System.print()
}

compareStrings.call("cat", "dog", true)
compareStrings.call("Rat", "RAT", true)
compareStrings.call("Rat", "RAT", false)
compareStrings.call("1100", "200", true)
