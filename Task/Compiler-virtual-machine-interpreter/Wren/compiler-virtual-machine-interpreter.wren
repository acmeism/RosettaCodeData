import "./dynamic" for Enum
import "./crypto" for Bytes
import "./fmt" for Conv
import "./ioutil" for FileUtil

var codes = [
    "fetch",
    "store",
    "push",
    "add",
    "sub",
    "mul",
    "div",
    "mod",
    "lt",
    "gt",
    "le",
    "ge",
    "eq",
    "ne",
    "and",
    "or",
    "neg",
    "not",
    "jmp",
    "jz",
    "prtc",
    "prts",
    "prti",
    "halt"
]

var Code = Enum.create("Code", codes)

var codeMap = {
    "fetch": Code.fetch,
    "store": Code.store,
    "push":  Code.push,
    "add":   Code.add,
    "sub":   Code.sub,
    "mul":   Code.mul,
    "div":   Code.div,
    "mod":   Code.mod,
    "lt":    Code.lt,
    "gt":    Code.gt,
    "le":    Code.le,
    "ge":    Code.ge,
    "eq":    Code.eq,
    "ne":    Code.ne,
    "and":   Code.and,
    "or":    Code.or,
    "neg":   Code.neg,
    "not":   Code.not,
    "jmp":   Code.jmp,
    "jz":    Code.jz,
    "prtc":  Code.prtc,
    "prts":  Code.prts,
    "prti":  Code.prti,
    "halt":  Code.halt
}

var object     = []
var stringPool = []

var reportError = Fn.new { |msg| Fiber.abort("error : %(msg)") }

var emitByte = Fn.new { |c| object.add(c) }

var emitWord = Fn.new { |n|
    var bs = Bytes.fromIntLE(n)
    for (b in bs) emitByte.call(b)
}

// Converts the 4 bytes starting at object[pc] to an unsigned 32 bit integer
// and thence to a signed 32 bit integer
var toInt32LE = Fn.new { |pc|
    var x = Bytes.toIntLE(object[pc...pc+4])
    if (x >= 2.pow(31)) x = x - 2.pow(32)
    return x
}

/* Virtual Machine interpreter */

var runVM = Fn.new { |dataSize|
    var stack = List.filled(dataSize + 1, 0)
    var pc = 0
    while (true) {
        var op = object[pc]
        pc = pc + 1
        if (op == Code.fetch) {
            var x = toInt32LE.call(pc)
            stack.add(stack[x])
            pc = pc + 4
        } else if (op == Code.store) {
            var x = toInt32LE.call(pc)
            var ln = stack.count
            stack[x] = stack[ln-1]
            stack = stack[0...ln-1]
            pc = pc + 4
        } else if (op == Code.push) {
            var x = toInt32LE.call(pc)
            stack.add(x)
            pc = pc + 4
        } else if (op == Code.add) {
            var ln = stack.count
            stack[ln-2] = stack[ln-2] + stack[ln-1]
            stack = stack[0...ln-1]
        } else if (op == Code.sub) {
            var ln = stack.count
            stack[ln-2] = stack[ln-2] - stack[ln-1]
            stack = stack[0...ln-1]
        } else if (op == Code.mul) {
            var ln = stack.count
            stack[ln-2] = stack[ln-2] * stack[ln-1]
            stack = stack[0...ln-1]
        } else if (op == Code.div) {
            var ln = stack.count
            stack[ln-2] = (stack[ln-2] / stack[ln-1]).truncate
            stack = stack[0...ln-1]
        } else if (op == Code.mod) {
            var ln = stack.count
            stack[ln-2] = stack[ln-2] % stack[ln-1]
            stack = stack[0...ln-1]
        } else if (op == Code.lt) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(stack[ln-2] < stack[ln-1])
            stack = stack[0...ln-1]
        } else if (op == Code.gt) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(stack[ln-2] > stack[ln-1])
            stack = stack[0...ln-1]
        } else if (op == Code.le) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(stack[ln-2] <= stack[ln-1])
            stack = stack[0...ln-1]
        } else if (op == Code.ge) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(stack[ln-2] >= stack[ln-1])
            stack = stack[0...ln-1]
        } else if (op == Code.eq) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(stack[ln-2] == stack[ln-1])
            stack = stack[0...ln-1]
        } else if (op == Code.ne) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(stack[ln-2] != stack[ln-1])
            stack = stack[0...ln-1]
        } else if (op == Code.and) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(Conv.itob(stack[ln-2]) && Conv.itob(stack[ln-1]))
            stack = stack[0...ln-1]
        } else if (op == Code.or) {
            var ln = stack.count
            stack[ln-2] = Conv.btoi(Conv.itob(stack[ln-2]) || Conv.itob(stack[ln-1]))
            stack = stack[0...ln-1]
        } else if (op == Code.neg) {
            var ln = stack.count
            stack[ln-1] = -stack[ln-1]
        } else if (op == Code.not) {
            var ln = stack.count
            stack[ln-1] = Conv.btoi(!Conv.itob(stack[ln-1]))
        } else if (op == Code.jmp) {
            var x = toInt32LE.call(pc)
            pc = pc + x
        } else if (op == Code.jz) {
            var ln = stack.count
            var v = stack[ln-1]
            stack = stack[0...ln-1]
            if (v != 0) {
                pc = pc + 4
            } else {
                var x = toInt32LE.call(pc)
                pc = pc + x
            }
        } else if (op == Code.prtc) {
            var ln = stack.count
            System.write(String.fromByte(stack[ln-1]))
            stack = stack[0...ln-1]
        } else if (op == Code.prts) {
            var ln = stack.count
            System.write(stringPool[stack[ln-1]])
            stack = stack[0...ln-1]
        } else if (op == Code.prti) {
            var ln = stack.count
            System.write(stack[ln-1])
            stack = stack[0...ln-1]
        } else if (op == Code.halt) {
            return
        } else {
            reportError.call("Unknown opcode %(op)")
        }
    }
}

var translate = Fn.new { |s|
    var d = ""
    var i = 0
    while (i < s.count) {
        if (s[i] == "\\" && (i+1) < s.count) {
            if (s[i+1] == "n") {
                d = d + "\n"
                i = i + 1
            } else if (s[i+1] == "\\") {
                d = d + "\\"
                i = i + 1
            }
        } else {
            d = d + s[i]
        }
        i = i + 1
    }
    return d
}

var lines = []
var lineCount = 0
var lineNum = 0

var loadCode = Fn.new {
    var dataSize
    var firstLine = true
    while (lineNum < lineCount) {
        var line = lines[lineNum].trimEnd(" \t")
        lineNum = lineNum + 1
        if (line.count == 0) {
            if (firstLine) {
                reportError.call("empty line")
            } else {
                break
            }
        }
        var lineList = line.split(" ").where { |s| s != "" }.toList
        if (firstLine) {
            dataSize = Num.fromString(lineList[1])
            var nStrings = Num.fromString(lineList[3])
            for (i in 0...nStrings) {
                var s = lines[lineNum].trim("\"\n")
                lineNum = lineNum + 1
                stringPool.add(translate.call(s))
            }
            firstLine = false
            continue
        }
        var offset = Num.fromString(lineList[0])
        var instr = lineList[1]
        var opCode = codeMap[instr]
        if (!opCode) {
            reportError.call("Unknown instruction %(instr) at %(opCode)")
        }
        emitByte.call(opCode)
        if (opCode == Code.jmp || opCode == Code.jz) {
            var p = Num.fromString(lineList[3])
            emitWord.call(p - offset - 1)
        } else if (opCode == Code.push) {
            var value = Num.fromString(lineList[2])
            emitWord.call(value)
        } else if (opCode == Code.fetch || opCode == Code.store) {
            var value = Num.fromString(lineList[2].trim("[]"))
            emitWord.call(value)
        }
    }
    return dataSize
}

lines = FileUtil.readLines("codegen.txt")
lineCount = lines.count
runVM.call(loadCode.call())
