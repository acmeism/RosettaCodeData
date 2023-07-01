import "/fmt" for Conv

var ranges = [ 0..25, 250..265, 1000..1025 ]
for (r in ranges) {
    r.each { |i| System.write("%(Conv.ord(i))  ") }
    System.print("\n")
}
