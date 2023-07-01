import "/str" for Str, Utf8

var strs = ["alphaBETA", "ação", "o'hare O'HARE o’hare don't"]
System.print("Using 'Str' class methods:")
for (s in strs) {
    System.print("  original   : %(s)")
    System.print("  lower      : %(Str.lower(s))")
    System.print("  upper      : %(Str.upper(s))")
    System.print("  capitalize : %(Str.capitalize(s))")
    System.print("  title      : %(Str.title(s))")
    System.print("  swapCase   : %(Str.swapCase(s))")
    System.print()
}
var strs2 = ["Stroßbùrri", "ĥåçýджк", "Ǆǈǌ"]
System.print("Using 'Utf8' class methods:")
for (s in strs2) {
    System.print("  original   : %(s)")
    System.print("  lower      : %(Utf8.lower(s))")
    System.print("  upper      : %(Utf8.upper(s))")
    System.print("  capitalize : %(Utf8.capitalize(s))")
    System.print("  title      : %(Utf8.title(s))")
    System.print()
}
