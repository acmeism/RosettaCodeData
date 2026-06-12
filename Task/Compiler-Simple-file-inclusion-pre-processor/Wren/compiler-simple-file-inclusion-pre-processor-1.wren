import "io" for File

var source = File.read("source.wren")

var ix
var start = 0
while ((ix = source.indexOf("import", start)) && ix >= 0) {
    var ix2 = source.indexOf("\n", ix + 6)
    if (ix2 == -1) ix2 = source.count
    start = ix + 1
    var imp = source[ix...ix2]
    var tokens = imp.split(" ").where { |s| s != "" }.toList
    var filePath = tokens[1][1...-1]
    if (filePath.startsWith("./")) {
        filePath = filePath[2..-1]
    } else if (filePath.startsWith("/")) {
        filePath = filePath[1..-1]
    } else {
        continue // leave resolution of other modules to compiler
    }
    var text = File.read(filePath + ".wren")
    source = source[0...ix] + "\n%(text)\n" + source[ix2..-1]
}

File.create("source2.wren") { |file| file.writeBytes(source) }
