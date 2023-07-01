import "io" for Stdin

// Return a.length - b.length if positive, 0 otherwise.
var longer = Fn.new { |a, b|
    while (!a.isEmpty && !b.isEmpty) {
        a = a[1..-1]
        b = b[1..-1]
    }
    return a.count
}

var longest = ""
var lines = ""
var line
while ((line = Stdin.readLine()) != "") {
    if (longer.call(line, longest) != 0) {
        lines = longest = line
    } else if (longer.call(longest, line) == 0) {
        lines = "%(lines)\n%(line)"
    }
}
System.print(lines)
