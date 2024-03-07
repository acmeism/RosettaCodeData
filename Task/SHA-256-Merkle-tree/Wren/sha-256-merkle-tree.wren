import "io" for File
import "./crypto" for Sha256, Bytes
import "./seq" for Lst
import "./str" for Str
import "./fmt" for Conv

var bytes = File.read("title.png").bytes.toList
var chunks = Lst.chunks(bytes, 1024)
var hashes = List.filled(chunks.count, null)
var i = 0
for (chunk in chunks) {
   var h = Sha256.digest(chunk.map { |b| String.fromByte(b) }.join())
   hashes[i] = Str.chunks(h, 2).map { |x| Conv.atoi(x, 16) }.toList
   i = i + 1
}

var buffer = List.filled(64, 0)
while (hashes.count > 1) {
    var hashes2 = []
    var i = 0
    while (i < hashes.count) {
        if (i < hashes.count - 1) {
            for (j in  0..31) buffer[j] = hashes[i][j]
            for (j in  0..31) buffer[j+32] = hashes[i+1][j]
            var h = Sha256.digest(buffer.map { |b| String.fromByte(b) }.join())
            var hb = Str.chunks(h, 2).map { |x| Conv.atoi(x, 16) }.toList
            hashes2.add(hb)
        } else {
            hashes2.add(hashes[i])
        }
        i = i + 2
    }
    hashes = hashes2
}
System.print(Bytes.toHexString(hashes[0]))
