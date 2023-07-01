import "/str" for Str

var printVerse = Fn.new { |name|
    var x = Str.capitalize(Str.lower(name))
    var z = x[0]
    var y = "AEIOU".contains(z) ? Str.lower(x) : x[1..-1]
    var b = "b%(y)"
    var f = "f%(y)"
    var m = "m%(y)"
    if (z == "B") {
        b = y
    } else if (z == "F") {
        f = y
    } else if (z == "M") {
        m = y
    }
    System.print("%(x), %(x), bo-%(b)")
    System.print("Banana-fana fo-%(f)")
    System.print("Fee-fi-mo-%(m)")
    System.print("%(x)!\n")
}

["Gary", "Earl", "Billy", "Felix", "Mary", "Steve"].each { |name| printVerse.call(name) }
