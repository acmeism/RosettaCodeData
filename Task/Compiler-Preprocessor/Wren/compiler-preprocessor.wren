import "os" for Process
import "./ioutil" for FileUtil, File, Input
import "./str" for Char
import "./pattern" for Pattern
import "./seq" for Lst, Stack

var isIdentChar = Fn.new { |c| Char.isAsciiAlphaNum(c) || c == "_" }

var isIdent = Fn.new { |s|
    if (s == "") return false
    if (Char.isDigit(s[0])) return false
    return s.all { |c| isIdentChar.call(c) }
}

var clargs = Process.arguments
if (clargs.count > 3) {
    System.print("There can't be more than 3 command line arguments:
        -d     // debug mode, comments will be included in output
        input  // filename: if absent  or  == console, gets input from console
        output // filename: if absent  or  == console, sends output to console")
    return
}
var debug = clargs.contains("-d") || clargs.contains("--debug")
if (debug) {
    clargs.remove("-d")
    clargs.remove("--debug")
}
var inputFileName = "console"
if (clargs.count > 0) inputFileName = clargs[0]
var lines
if (inputFileName != "console") {
   lines = FileUtil.readLines(inputFileName)
} else {
    var n = Input.integer("How many lines are to be entered? : ", 1)
    System.print("\nOK, enter the lines and press enter after each one.\n")
    lines = List.filled(n, null)
    for (i in 0...n) lines[i] = Input.text("")
    System.print()
}

var macros = []
var comments = []
var used = []
var includes = Stack.new()
var i = 0
while (i < lines.count) {
    var line = lines[i].trim()
    if (line == "" || !line.startsWith("#")) {
        i = i + 1
    } else if (line.startsWith("#include")) {
        var fname = line[8..-1].trimStart()
        if (fname.count < 3 || fname[0] != "\"" || fname[-1] != "\"") {
            Fiber.abort("'#include' directive must be followed by a non-empty string.")
        }
        var lines2 = FileUtil.readLines(fname[1..-2])
        if (includes.count == 5) {
            Fiber.abort("Can't have more than 5 active 'include' files.")
        } else {
            includes.push([fname, i + lines2.count - 1])
            if (debug) comments.add("/* Include Header %(fname) */")
        }
        lines = lines[0...i] + lines2 + lines[i+1..-1]
    } else if (line.startsWith("#define")) {
        line = line[7..-1].trimStart()
        if (line == "") Fiber.abort("Missing macro name.")
        var name = ""
        var j = 0
        while (j < line.count) {
            var c = line[j]
            if (isIdentChar.call(c)) name = name + c else break
            j = j + 1
        }
        if (name == "") Fiber.abort("Missing macro name.")
        if (!isIdent.call(name)) Fiber.abort("Macro name is not a valid identifier.")
        if (macros.any { |macro| macro[0] == name }) Fiber.abort("Macro '%(name)' cannot be redefined.")
        if (j == line.count) Fiber.abort("Missing macro definition.")
        var paramStr = ""
        var params = null
        if (line[j] == "(") {
            j = j + 1
            var k = line.indexOf(")", j)
            if (k == -1) Fiber.abort("Missing ')' in macro parameter list.")
            if (k == j) {
                params = []
            } else {
                paramStr = line[j...k]
                params = paramStr.split(",")
                params = params.map { |param| param.trim() }.toList
                if (!params.all { |param| isIdent.call(param) }) {
                    Fiber.abort("Macro parameter is not a valid identifier.")
                }
            }
            j = k + 1
        }
        if (j == line.count) Fiber.abort("Missing macro definition.")
        var defn = line[j..-1].trimStart()
        macros.add([name, params, defn])
        if (debug) {
            if (params == null) {
                comments.add("/* Define %(name) as %(defn) */")
            } else {
                comments.add("/* Define %(name)(%(params.toString[1...-1])) as %(defn) */")
            }
        }
        lines.removeAt(i)
    } else {
        Fiber.abort("Unknown directive.")
    }
    if (debug) {
        while (includes.count > 0 && i >= includes.peek()[1]) {
            comments.add("/* End %(includes.pop()[0]) */")
        }
    }
}
var src = lines.where { |line| line != "" }.join("\n")
for (macro in macros) {
    var name   = macro[0]
    var params = macro[1]
    var defn   = macro[2]
    var p
    if (params == null) {
        p = Pattern.new("/X[%(name)]~/X")
    } else if (params.count == 0) {
        p = Pattern.new("[/#%(name)()/#]")
    } else if (params.count > 0) {
        p = Pattern.new("[/#%(name)(+1^))/#]")
    }
    var m = null
    while (m = p.find(src)) {
        var span = m.captures[0].span
        if (params == null || params.count == 0) {
            src = src[0...span[0]] + defn + src[span[1]+1..-1]
            used.add(name)
        } else {
            var argStr = m.captures[0].text
            var ix1 = argStr.indexOf("(") + 1
            var ix2 = argStr.indexOf(")") - 1
            argStr = argStr[ix1..ix2]
            var args = argStr.split(",")
            if (args.count == params.count) {
                var temp = " " + defn + " "
                for (i in 0...args.count) {
                    temp = temp.replace(" " + params[i] + " ", " " + args[i].trim() + " ")
                }
                src = src[0...span[0]] + temp.trim() + src[span[1]+1..-1]
                used.add(name)
            }
        }
    }
}
if (debug) {
    while (includes.count > 0) {
        comments.add("/* End %(includes.pop()[0]) */")
    }
}
used = Lst.distinct(used)
if (used.count > 0) {
    var temp = (used.count == 1) ? used[0] : used[0..-2].join(", ") + " and " + used[-1]
    if (debug) comments.add("/* Used %(temp) */")
}
if (debug) comments = comments.join("\n")

var outputFileName = "console"
if (clargs.count > 1) outputFileName = clargs[1]

if (outputFileName == "console") {
    System.print("Output:\n")
    if (debug) System.print(comments)
    System.print(src)
} else {
    File.create(outputFileName) { |file|
        if (debug) {
            file.writeBytes(comments)
            file.writeBytes("\n")
        }
        file.writeBytes(src)
        file.writeBytes("\n")
    }
}
