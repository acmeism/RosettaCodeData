import "io" for File

File.open("/dev/urandom") { |file|
    var b = file.readBytes(4).bytes.toList
    var n = b[0] | b[1] << 8 | b[2] << 16 | b[3] << 24
    System.print(n)
}
