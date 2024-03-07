import "./sort" for Sort
import "./fmt" for Fmt

var sort3 = Fn.new { |x, y, z|
    var a = [x, y, z]
    Sort.insertion(a)
    x = a[0]
    y = a[1]
    z = a[2]
    Fmt.print("  x = $s\n  y = $s\n  z = $s", x, y, z)
}

System.print("After sorting strings:")
var x = "lions, tigers, and"
var y = "bears, oh my!"
var z = "(from the \"Wizard of OZ\")"
sort3.call(x, y, z)

System.print("\nAfter sorting integers:")
x = 77444
y = -12
z = 0
sort3.call(x, y, z)

System.print("\nAfter sorting floats:")
x = 11.3
y = -9.7
z = 11.17
sort3.call(x, y, z)
