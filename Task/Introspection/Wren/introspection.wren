import "os" for Platform, Process
import "io" for File
import "meta" for Meta
import "./pattern" for Pattern
import "./math" for Nums

var a = 4    /* 1st integer variable */
var b = 0xA  /* 2nd integer variable */
var c = -8   /* 3rd integer variable */

var bloop = -17.3

var checkVersion = Fn.new {
    var version = Process.version
    var components = version.split(".")
    if (Num.fromString(components[1]) < 4) {
        Fiber.abort("Wren version (%(version)) is too old.")
    }
}

var globalIntVars = Fn.new {
    var sep = Platform.isWindows ? "\r\n" : "\n"
    var lines = File.read(Process.allArguments[1]).split(sep)
    var p = Pattern.new("var+1/s[+1/x]+1/s/=+1/s[0x+1/h|~-+1/d]+0/s", Pattern.whole)
    var q = Pattern.new("[////|//*]+0/z", Pattern.end)
    var vars = []
    var vals = []
    for (line in lines) {
        line = q.replaceAll(line, "") // get rid of any comments
        var m = p.find(line)
        if (m) {
            vars.add(m.capsText[0])
            vals.add(Num.fromString(m.capsText[1]))
        }
    }
    return [vars, vals]
}

checkVersion.call()
var res = globalIntVars.call()
var d
Meta.eval("d = bloop.abs") // this won't compile if either 'bloop' or 'abs' not available
System.print("bloop.abs = %(d)")
var vars = res[0]
var vals = res[1]
System.print("The sum of the %(vars.count) integer variables, %(vars), is %(Nums.sum(vals))")
