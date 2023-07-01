import "io" for Stdin

// 'raw' is a multi-line string
var snusp = Fn.new { |dlen, raw|
    var ds = List.filled(dlen, 0) // data store
    var dp = 0 // data pointer

    // remove leading \n if it's there
    if (raw[0] == "\n") raw = raw[1..-1]

    // make 2 dimensional instruction store & declare instruction pointers
    var s = raw.split("\n")
    var ipr = 0
    var ipc = 0

    // look for starting instruction
    for (r in 0...s.count) {
        var row = s[r]
        var outer = false
        for (c in 0...row.count) {
            var i = row[c]
            if (i == "$") {
                ipr = r
                ipc = c
                outer = true
                break
            }
        }
        if (outer) break
    }

    var id = 0
    var step = Fn.new {
        if (id&1 == 0) {
            ipc = ipc + 1 - (id&2)
        } else {
            ipr = ipr + 1 - (id&2)
        }
    }

    // execute
    while (ipr >= 0 && ipr < s.count && ipc >= 0 && ipc < s[ipr].count) {
        var c = s[ipr][ipc]
        if (c == ">") {
            dp = dp + 1
        } else if (c == "<") {
            dp = dp - 1
        } else if (c == "+") {
            ds[dp] = ds[dp] + 1
        } else if (c == "-") {
            ds[dp] = ds[dp] - 1
        } else if (c == ".") {
            System.write(String.fromByte(ds[dp]))
        } else if (c == ",") {
            ds[dp] = Stdin.readByte()
        } else if (c == "/") {
            id = ~id
        } else if (c == "\\") {
            id = id ^ 1
        } else if (c == "!") {
            step.call()
        } else if (c == "?") {
            if (ds[dp] == 0) step.call()
        }
        step.call()
    }
}

var hw =
    "/++++!/===========?\\>++.>+.+++++++..+++\\\n" +
    "\\+++\\ | /+>+++++++>/ /++++++++++<<.++>./\n" +
    "$+++/ | \\+++++++++>\\ \\+++++.>.+++.-----\\\n" +
    "      \\==-<<<<+>+++/ /=.>.+>.--------.-/"
snusp.call(5, hw)
