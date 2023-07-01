import "/dynamic" for Tuple
import "/fmt" for Fmt
import "/big" for BigInt

var Result = Tuple.create("Result", ["name", "size", "start", "end"])

var validate = Fn.new { |diagram|
    var lines = []
    for (line in diagram.split("\n")) {
        line = line.trim(" \t")
        if (line != "") lines.add(line)
    }
    if (lines.count == 0) Fiber.abort("diagram has no non-empty lines!")
    var width = lines[0].count
    var cols = ((width - 1) / 3).floor
    if (cols != 8 && cols != 16 && cols != 32 && cols != 64) {
        Fiber.abort("number of columns should be 8, 16, 32 or 64")
    }
    if (lines.count%2 == 0) {
        Fiber.abort("number of non-empty lines should be odd")
    }
    if (lines[0] != "+--" * cols + "+") Fiber.abort("incorrect header line")
    var i = 0
    for (line in lines) {
        if (i == 0) {
            continue
        } else if (i%2 == 0) {
            if (line != lines[0]) Fiber.abort("incorrect separator line")
        } else if (line.count != width) {
            Fiber.abort("inconsistent line widths")
        } else if (line[0] != "|" || line[width-1] != "|") {
            Fiber.abort("non-separator lines must begin and end with '|'")
        }
        i = i + 1
    }
    return lines
}

var decode = Fn.new { |lines|
    System.print("Name     Bits  Start  End")
    System.print("=======  ====  =====  ===")
    var start = 0
    var width = lines[0].count
    var results = []
    var i = 0
    for (line in lines) {
        if (i%2 == 0) {
            i = i + 1
            continue
        }
        line = line[1...width-1]
        for (name in line.split("|")) {
            var size = ((name.count + 1) / 3).floor
            name = name.trim()
            var r = Result.new(name, size, start, start + size - 1)
            results.add(r)
            Fmt.print("$-7s   $2d    $3d   $3d", r.name, r.size, r.start, r.end)
            start = start + size
        }
        i = i + 1
    }
    return results
}

var hex2bin = Fn.new { |hex|
    var z = BigInt.fromBaseString(hex, 16)
    return Fmt.swrite("$0%(4*hex.count)s", z.toBaseString(2))
}

var unpack = Fn.new { |results, hex|
    System.print("\nTest string in hex:")
    System.print(hex)
    System.print("\nTest string in binary:")
    var bin = hex2bin.call(hex)
    System.print(bin)
    System.print("\nUnpacked:\n")
    System.print("Name     Size  Bit pattern")
    System.print("=======  ====  ================")
    for (res in results) {
        Fmt.print("$-7s   $2d   $s", res.name, res.size, bin[res.start..res.end])
    }
}

var diagram = """
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                      ID                       |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    QDCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

    |                    ANCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    NSCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ARCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
"""
var lines = validate.call(diagram)
System.print("Diagram after trimming whitespace and removal of blank lines:\n")
for (line in lines) System.print(line)
System.print("\nDecoded:\n")
var results = decode.call(lines)
var hex = "78477bbf5496e12e1bf169a4" // test string
unpack.call(results, hex)
