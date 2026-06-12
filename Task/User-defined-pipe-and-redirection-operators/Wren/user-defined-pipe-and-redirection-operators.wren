import "./seq" for Lst

var FS = {}   // fake file system

var JoinUp = Fn.new { |lines| lines.join("\n") + "\n" }

class Pipe {  // fake pipe
    static fromName(name) { Pipe.new(FS[name]) }  // role of < operator

    static multireader(pipes) {
        var res = Pipe.new("")
        for (i in 0...pipes.count) {
            var p = pipes[i]
            res.putln(p.rawData)
        }
        return res
    }

    construct new(data) {
        _data = data
        _idx = -1
    }

    getln() {
        if (_idx < _data.count-1) {
            var start = _idx + 1
            _idx = _data.indexOf("\n", start)
            return (_idx >= 0) ? _data[start.._idx] : ""
        }
        return ""
    }

    putln(line) { _data = _data + line }

    readAll() { _data.split("\n").where { |s| s != "" }.toList }

    rawData { _data }

    toName(name) { FS[name] = _data }   // role of > operator

    tee(name) { Pipe.new(FS[name] = _data) }

    grep(pat) {
        var res = Pipe.new("")
        while (true) {
            var line = getln()
            if (line == "") break
            if (line.indexOf(pat) >= 0) res.putln(line)
        }
        return res
    }

    head(lines) { Pipe.new(JoinUp.call(readAll().take(lines).toList)) }

    tail(lines) {
        var t = readAll()
        if (t.count >= lines) t = t[-lines..-1]
        return Pipe.new(JoinUp.call(t))
    }

    sortUnique { Pipe.new(JoinUp.call(Lst.distinct(readAll()))) }
}

var showCount = Fn.new { |heading, name|
    if (!FS[name]) Fiber.abort("not found")
    var n = FS[name].split("\n").count { |s| s != "" }
    System.print("%(heading): %(n)")
}

var lcsTxt = """
Wil van der Aalst        business process management, process mining, Petri nets
Hal Abelson              intersection of computing and teaching
Serge Abiteboul          database theory
Samson Abramsky          game semantics
Leonard Adleman          RSA, DNA computing
Manindra Agrawal         polynomial-time primality testing
Luis von Ahn             human-based computation
Alfred Aho               compilers book, the 'a' in AWK
Stephen R. Bourne        Bourne shell, portable ALGOL 68C compiler
Kees Koster              ALGOL 68
Lambert Meertens         ALGOL 68, ABC (programming language)
Peter Naur               BNF, ALGOL 60
Guido van Rossum         Python (programming language)
Adriaan van Wijngaarden  Dutch pioneer; ARRA, ALGOL
Dennis E. Wisnosky       Integrated Computer-Aided Manufacturing (ICAM), IDEF
Stephen Wolfram          Mathematica
William Wulf             compilers
Edward Yourdon           Structured Systems Analysis and Design Method
Lotfi Zadeh              fuzzy logic
Arif Zaman               Pseudo-random number generator
Albert Zomaya            Australian pioneer of scheduling in parallel and distributed systems
Konrad Zuse              German pioneer of hardware and software
"""

var mainList = "List_of_computer_scientists.lst"
FS[mainList] = lcsTxt
var p = Pipe.fromName(mainList)
var pipes = [p.head(4), p.grep("ALGOL").tee("ALGOL_pioneers.lst"), p.tail(4)]
var p2 = Pipe.multireader(pipes).sortUnique.tee("the_important_scientists.lst").grep("aa").toName("aa")
System.write("Pioneer: %(FS["aa"])")
showCount.call("Number of ALGOL pioneers", "ALGOL_pioneers.lst")
showCount.call("Number of scientists", "the_important_scientists.lst")
