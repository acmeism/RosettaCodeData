import "io" for Stdin, Stdout

var subleq = Fn.new { |program|
    var words = program.split(" ").map { |w| Num.fromString(w) }.toList
    var sb = ""
    var ip = 0
    while (true) {
        var a = words[ip]
        var b = words[ip+1]
        var c = words[ip+2]
        ip = ip + 3
        if (a < 0) {
            System.write("Enter a character : ")
            Stdout.flush()
            words[b] = Num.fromString(Stdin.readLine()[0])
        } else if (b < 0) {
            sb = sb + String.fromByte(words[a])
        } else {
            words[b] = words[b] - words[a]
            if (words[b] <= 0) ip = c
            if (ip < 0) break
        }
    }
    System.write(sb)
}

var program = "15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1 72 101 108 108 111 44 32 119 111 114 108 100 33 10 0"
subleq.call(program)
