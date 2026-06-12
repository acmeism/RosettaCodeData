import "io" for File
import "./seq" for Lst
import "./fmt" for Fmt

class Dumper {
    static dump(fileName, base, start, length) {
        if ([2, 3, 8, 10, 16].indexOf(base) == -1) Fiber.abort("Base %(base) is not supported.")
        var bytes = File.read(fileName).bytes.toList
        var bc = bytes.count
        // remove final \n if present
        if (bc > 0 && bytes[-1] == 10) {
            bytes.removeAt(-1)
            bc = bc - 1
        } else if (bc > 1 && bytes[-1] == 0 && bytes[-2] == 10) {
            bytes.removeAt(-1)
            bytes.removeAt(-1)
            bc = bc - 2
        }
        if (bc == 0) Fmt.print("$q is empty.", fileName)
        if (start < 0 || start >= bc) Fiber.abort("Starting point is invalid.")
        if (length < 1 || length > bc - start) length = bc - start
        var end = start + length - 1
        if (start > 0 || end < bc - 1) {
            bytes = bytes[start..end]
            bc = end - start + 1
        }
        var rowLens = {2: 6, 3: 8, 8: 10, 10: 10, 16: 16}
        var rl = rowLens[base]
        var hrl = rl / 2
        var sp = (base < 8) ? " " : "  "
        var baseFmts = {2: "$08b", 3: "$06t", 8: "$03o", 10: "$03d", 16: "$02x"}
        var bf = baseFmts[base]
        var bl = Num.fromString(bf[2])
        var rows = Lst.chunks(bytes, rl)
        var rc = rows.count
        Fmt.print("Dump of $q in base $d from byte index $d to $d:", fileName, base, start, end)
        for (i in 0...rc) {
            var line = rows[i]
            var lc = line.count
            var ascii = List.filled(lc, 0)
            for (b in 0...lc) {
                var c = line[b]
                if (c >= 32 && c < 127) {
                    ascii[b] = String.fromByte(c)
                } else {
                    ascii[b] = "."
                }
            }
            var text = "|" + ascii.join() + "|"
            var offset = start + i * rl
            if (i < rc-1 || lc == rl) {
                var fmt = "$08x  %(bf)$s%(bf)  $s"
                Fmt.print(fmt, offset, line[0...hrl], sp, line[hrl..-1], text)
            } else {
                var extra = " " * ((bl+1) * (rl - lc))
                if (lc <= hrl) {
                    var fmt = "$08x  %(bf)$s$s $s"
                    Fmt.print(fmt, offset, line[0..-1], sp, extra, text)
                } else {
                    var fmt = "$08x  %(bf)$s%(bf)$s  $s"
                    Fmt.print(fmt, offset, line[0...hrl], sp, line[hrl..-1], extra, text)
                }
            }
        }
        Fmt.print("$08x", start + bc)
    }

    static dump(fileName, base, start) { dump(fileName, base, start, -1) }
    static dump(fileName, base)        { dump(fileName, base, 0, -1)     }
}

var fileName = "example_utf16.txt"
for (base in [16, 10, 8, 3, 2]) {
    Dumper.dump(fileName, base)
    System.print()
}
Dumper.dump(fileName, 16, 2, 24)
