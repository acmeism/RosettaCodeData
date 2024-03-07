import "./fmt" for Fmt

var ranges = [ 0..25, 250..265, 1000..1025 ]
for (r in ranges) {
    r.each { |i| Fmt.write("$r  ", i) }
    System.print("\n")
}
