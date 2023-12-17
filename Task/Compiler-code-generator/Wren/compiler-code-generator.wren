import "./dynamic" for Enum, Struct, Tuple
import "./crypto" for Bytes
import "./fmt" for Fmt
import "./ioutil" for FileUtil

var nodes = [
    "Ident",
    "String",
    "Integer",
    "Sequence",
    "If",
    "Prtc",
    "Prts",
    "Prti",
    "While",
    "Assign",
    "Negate",
    "Not",
    "Mul",
    "Div",
    "Mod",
    "Add",
    "Sub",
    "Lss",
    "Leq",
    "Gtr",
    "Geq",
    "Eql",
    "Neq",
    "And",
    "Or"
]

var Node = Enum.create("Node", nodes)

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

var Tree = Struct.create("Tree", ["nodeType", "left", "right", "value"])

// dependency: Ordered by Node value, must remain in same order as Node enum
var Atr = Tuple.create("Atr", ["enumText", "nodeType", "opcode"])

var atrs = [
    Atr.new("Identifier", Node.Ident, 255),
    Atr.new("String", Node.String, 255),
    Atr.new("Integer", Node.Integer, 255),
    Atr.new("Sequence", Node.Sequence, 255),
    Atr.new("If", Node.If, 255),
    Atr.new("Prtc", Node.Prtc, 255),
    Atr.new("Prts", Node.Prts, 255),
    Atr.new("Prti", Node.Prti, 255),
    Atr.new("While", Node.While, 255),
    Atr.new("Assign", Node.Assign, 255),
    Atr.new("Negate", Node.Negate, Code.neg),
    Atr.new("Not", Node.Not, Code.not),
    Atr.new("Multiply", Node.Mul, Code.mul),
    Atr.new("Divide", Node.Div, Code.div),
    Atr.new("Mod", Node.Mod, Code.mod),
    Atr.new("Add", Node.Add, Code.add),
    Atr.new("Subtract", Node.Sub, Code.sub),
    Atr.new("Less", Node.Lss, Code.lt),
    Atr.new("LessEqual", Node.Leq, Code.le),
    Atr.new("Greater", Node.Gtr, Code.gt),
    Atr.new("GreaterEqual", Node.Geq, Code.ge),
    Atr.new("Equal", Node.Eql, Code.eq),
    Atr.new("NotEqual", Node.Neq, Code.ne),
    Atr.new("And", Node.And, Code.and),
    Atr.new("Or", Node.Or, Code.or),
]

var stringPool = []
var globals    = []
var object     = []

var reportError = Fn.new { |msg| Fiber.abort("error : %(msg)") }

var nodeToOp = Fn.new { |nodeType| atrs[nodeType].opcode }

var makeNode = Fn.new { |nodeType, left, right| Tree.new(nodeType, left, right, "") }

var makeLeaf = Fn.new { |nodeType, value| Tree.new(nodeType, null, null, value) }

/* Code generator */

var emitByte = Fn.new { |c| object.add(c) }

var emitWord = Fn.new { |n|
    var bs = Bytes.fromIntLE(n)
    for (b in bs) emitByte.call(b)
}

var emitWordAt = Fn.new { |at, n|
    var bs = Bytes.fromIntLE(n)
    for (i in at...at+4) object[i] = bs[i-at]
}

var hole = Fn.new {
    var t = object.count
    emitWord.call(0)
    return t
}

var fetchVarOffset = Fn.new { |id|
    for (i in 0...globals.count) {
        if (globals[i] == id) return i
    }
    globals.add(id)
    return globals.count - 1
}

var fetchStringOffset = Fn.new { |st|
    for (i in 0...stringPool.count) {
        if (stringPool[i] == st) return i
    }
    stringPool.add(st)
    return stringPool.count - 1
}

var binOpNodes = [
    Node.Lss, Node.Gtr, Node.Leq, Node.Geq, Node.Eql, Node.Neq,
    Node.And, Node.Or, Node.Sub, Node.Add, Node.Div, Node.Mul, Node.Mod
]

var codeGen // recursive function
codeGen = Fn.new { |x|
    if (!x) return
    var n
    var p1
    var p2
    var nt = x.nodeType
    if (nt == Node.Ident) {
        emitByte.call(Code.fetch)
        n = fetchVarOffset.call(x.value)
        emitWord.call(n)
    } else if (nt == Node.Integer) {
        emitByte.call(Code.push)
        n = Num.fromString(x.value)
        emitWord.call(n)
    } else if (nt == Node.String) {
        emitByte.call(Code.push)
        n = fetchStringOffset.call(x.value)
        emitWord.call(n)
    } else if (nt == Node.Assign) {
        n = fetchVarOffset.call(x.left.value)
        codeGen.call(x.right)
        emitByte.call(Code.store)
        emitWord.call(n)
    } else if (nt == Node.If) {
        codeGen.call(x.left)       // if expr
        emitByte.call(Code.jz)     // if false, jump
        p1 = hole.call()           // make room forjump dest
        codeGen.call(x.right.left) // if true statements
        if (x.right.right) {
            emitByte.call(Code.jmp)
            p2 = hole.call()
        }
        emitWordAt.call(p1, object.count-p1)
        if (x.right.right) {
            codeGen.call(x.right.right)
            emitWordAt.call(p2, object.count-p2)
        }
    } else if (nt == Node.While) {
        p1 = object.count
        codeGen.call(x.left)                 // while expr
        emitByte.call(Code.jz)               // if false, jump
        p2 = hole.call()                     // make room for jump dest
        codeGen.call(x.right)                // statements
        emitByte.call(Code.jmp)              // back to the top
        emitWord.call(p1 - object.count)     // plug the top
        emitWordAt.call(p2, object.count-p2) // plug the 'if false, jump'
    } else if (nt == Node.Sequence) {
        codeGen.call(x.left)
        codeGen.call(x.right)
    } else if (nt == Node.Prtc) {
        codeGen.call(x.left)
        emitByte.call(Code.prtc)
    } else if (nt == Node.Prti) {
        codeGen.call(x.left)
        emitByte.call(Code.prti)
    } else if (nt == Node.Prts) {
        codeGen.call(x.left)
        emitByte.call(Code.prts)
    } else if (binOpNodes.contains(nt)) {
        codeGen.call(x.left)
        codeGen.call(x.right)
        emitByte.call(nodeToOp.call(x.nodeType))
    } else if (nt == Node.negate || nt == Node.Not) {
        codeGen.call(x.left)
        emitByte.call(nodeToOp.call(x.nodeType))
    } else {
        var msg = "error in code generator - found %(x.nodeType) expecting operator"
        reportError.call(msg)
    }
}

// Converts the 4 bytes starting at object[pc] to an unsigned 32 bit integer
// and thence to a signed 32 bit integer
var toInt32LE = Fn.new { |pc|
    var x = Bytes.toIntLE(object[pc...pc+4])
    if (x >= 2.pow(31)) x = x - 2.pow(32)
    return x
}

var codeFinish = Fn.new { emitByte.call(Code.halt) }

var listCode = Fn.new {
    Fmt.print("Datasize: $d Strings: $d", globals.count, stringPool.count)
    for (s in stringPool) System.print(s)
    var pc = 0
    while (pc < object.count) {
        Fmt.write("$5d ", pc)
        var op = object[pc]
        pc = pc + 1
        if (op == Code.fetch) {
            var x = toInt32LE.call(pc)
            Fmt.print("fetch [$d]", x)
            pc = pc + 4
        } else if (op == Code.store) {
            var x = toInt32LE.call(pc)
            Fmt.print("store [$d]", x)
            pc = pc + 4
        } else if (op == Code.push) {
            var x = toInt32LE.call(pc)
            Fmt.print("push  $d", x)
            pc = pc + 4
        } else if (op == Code.add) {
            System.print("add")
        } else if (op == Code.sub) {
            System.print("sub")
        } else if (op == Code.mul) {
            System.print("mul")
        } else if (op == Code.div) {
            System.print("div")
        } else if (op == Code.mod) {
            System.print("mod")
        } else if (op == Code.lt) {
            System.print("lt")
        } else if (op == Code.gt) {
            System.print("gt")
        } else if (op == Code.le) {
            System.print("le")
        } else if (op == Code.ge) {
            System.print("ge")
        } else if (op == Code.eq) {
            System.print("eq")
        } else if (op == Code.ne) {
            System.print("ne")
        } else if (op == Code.and) {
            System.print("and")
        } else if (op == Code.or) {
            System.print("or")
        } else if (op == Code.neg) {
            System.print("neg")
        } else if (op == Code.not) {
            System.print("not")
        } else if (op == Code.jmp) {
            var x = toInt32LE.call(pc)
            Fmt.print("jmp    ($d) $d", x, pc+x)
            pc = pc + 4
        } else if (op == Code.jz) {
            var x = toInt32LE.call(pc)
            Fmt.print("jz     ($d) $d", x, pc+x)
            pc = pc + 4
        } else if (op == Code.prtc) {
            System.print("prtc")
        } else if (op == Code.prti){
            System.print("prti")
        } else if (op == Code.prts) {
            System.print("prts")
        } else if (op == Code.halt) {
            System.print("halt")
        } else {
            reportError.call("listCode: Unknown opcode %(op)")
        }
    }
}

var getEnumValue = Fn.new { |name|
    for (atr in atrs) {
        if (atr.enumText == name) return atr.nodeType
    }
    reportError.call("Unknown token %(name)")
}

var lines = []
var lineCount = 0
var lineNum = 0

var loadAst  // recursive function
loadAst = Fn.new {
    var nodeType = 0
    var s = ""
    if (lineNum < lineCount) {
        var line = lines[lineNum].trimEnd(" \t")
        lineNum = lineNum + 1
        var tokens = line.split(" ").where { |s| s != "" }.toList
        var first = tokens[0]
        if (first[0] == ";") return null
        nodeType = getEnumValue.call(first)
        var le = tokens.count
        if (le == 2) {
            s = tokens[1]
        } else if (le > 2) {
            var idx = line.indexOf("\"")
            s = line[idx..-1]
        }
    }
    if (s != "") return makeLeaf.call(nodeType, s)
    var left  = loadAst.call()
    var right = loadAst.call()
    return makeNode.call(nodeType, left, right)
}

lines = FileUtil.readLines("ast.txt")
lineCount = lines.count
codeGen.call(loadAst.call())
codeFinish.call()
listCode.call()
