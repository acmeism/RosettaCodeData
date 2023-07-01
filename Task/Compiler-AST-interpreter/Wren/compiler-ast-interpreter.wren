import "/dynamic" for Enum, Struct, Tuple
import "/fmt" for Conv
import "/ioutil" for FileUtil

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

var Tree = Struct.create("Tree", ["nodeType", "left", "right", "value"])

// dependency: Ordered by Node value, must remain in same order as Node enum
var Atr = Tuple.create("Atr", ["enumText", "nodeType"])

var atrs = [
    Atr.new("Identifier", Node.Ident),
    Atr.new("String", Node.String),
    Atr.new("Integer", Node.Integer),
    Atr.new("Sequence", Node.Sequence),
    Atr.new("If", Node.If),
    Atr.new("Prtc", Node.Prtc),
    Atr.new("Prts", Node.Prts),
    Atr.new("Prti", Node.Prti),
    Atr.new("While", Node.While),
    Atr.new("Assign", Node.Assign),
    Atr.new("Negate", Node.Negate),
    Atr.new("Not", Node.Not),
    Atr.new("Multiply", Node.Mul),
    Atr.new("Divide", Node.Div),
    Atr.new("Mod", Node.Mod),
    Atr.new("Add", Node.Add),
    Atr.new("Subtract", Node.Sub),
    Atr.new("Less", Node.Lss),
    Atr.new("LessEqual", Node.Leq),
    Atr.new("Greater", Node.Gtr),
    Atr.new("GreaterEqual", Node.Geq),
    Atr.new("Equal", Node.Eql),
    Atr.new("NotEqual", Node.Neq),
    Atr.new("And", Node.And),
    Atr.new("Or", Node.Or),
]

var stringPool = []
var globalNames = []
var globalValues = {}

var reportError = Fn.new { |msg| Fiber.abort("error : %(msg)") }

var makeNode = Fn.new { |nodeType, left, right| Tree.new(nodeType, left, right, 0) }

var makeLeaf = Fn.new { |nodeType, value| Tree.new(nodeType, null, null, value) }

// interpret the parse tree
var interp  // recursive function
interp = Fn.new { |x|
    if (!x) return 0
    var nt = x.nodeType
    if (nt == Node.Integer) return x.value
    if (nt == Node.Ident) return globalValues[x.value]
    if (nt == Node.String) return x.value
    if (nt == Node.Assign) {
        var n = interp.call(x.right)
        globalValues[x.left.value] = n
        return n
    }
    if (nt == Node.Add) return interp.call(x.left) +  interp.call(x.right)
    if (nt == Node.Sub) return interp.call(x.left) -  interp.call(x.right)
    if (nt == Node.Mul) return interp.call(x.left) *  interp.call(x.right)
    if (nt == Node.Div) return (interp.call(x.left) / interp.call(x.right)).truncate
    if (nt == Node.Mod) return interp.call(x.left) %  interp.call(x.right)
    if (nt == Node.Lss) return Conv.btoi(interp.call(x.left) <  interp.call(x.right))
    if (nt == Node.Gtr) return Conv.btoi(interp.call(x.left) >  interp.call(x.right))
    if (nt == Node.Leq) return Conv.btoi(interp.call(x.left) <= interp.call(x.right))
    if (nt == Node.Eql) return Conv.btoi(interp.call(x.left) == interp.call(x.right))
    if (nt == Node.Neq) return Conv.btoi(interp.call(x.left) != interp.call(x.right))
    if (nt == Node.And) return Conv.btoi(Conv.itob(interp.call(x.left)) && Conv.itob(interp.call(x.right)))
    if (nt == Node.Or)  return Conv.btoi(Conv.itob(interp.call(x.left)) || Conv.itob(interp.call(x.right)))
    if (nt == Node.Negate) return -interp.call(x.left)
    if (nt == Node.Not) return (interp.call(x.left) == 0) ? 1 : 0
    if (nt == Node.If) {
        if (interp.call(x.left) != 0) {
            interp.call(x.right.left)
        } else {
            interp.call(x.right.right)
        }
        return 0
    }
    if (nt == Node.While) {
        while (interp.call(x.left) != 0) interp.call(x.right)
        return 0
    }
    if (nt == Node.Prtc) {
        System.write(String.fromByte(interp.call(x.left)))
        return 0
    }
    if (nt == Node.Prti) {
        System.write(interp.call(x.left))
        return 0
    }
    if (nt == Node.Prts) {
        System.write(stringPool[interp.call(x.left)])
        return 0
    }
    if (nt == Node.Sequence) {
        interp.call(x.left)
        interp.call(x.right)
        return 0
    }
    reportError.call("interp: unknown tree type %(x.nodeType)")
}

var getEnumValue = Fn.new { |name|
    for (atr in atrs) {
        if (atr.enumText == name) return atr.nodeType
    }
    reportError.call("Unknown token %(name)")
}

var fetchStringOffset = Fn.new { |s|
    var d = ""
    s = s[1...-1]
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
    s = d
    for (i in 0...stringPool.count) {
        if (s == stringPool[i]) return i
    }
    stringPool.add(s)
    return stringPool.count - 1
}

var fetchVarOffset = Fn.new { |name|
    for (i in 0...globalNames.count) {
        if (globalNames[i] == name) return i
    }
    globalNames.add(name)
    return globalNames.count - 1
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
    if (s != "") {
        var n
        if (nodeType == Node.Ident) {
            n = fetchVarOffset.call(s)
        } else if (nodeType == Node.Integer) {
            n = Num.fromString(s)
        } else if (nodeType == Node.String) {
            n = fetchStringOffset.call(s)
        } else {
            reportError.call("Unknown node type: %(s)")
        }
        return makeLeaf.call(nodeType, n)
    }
    var left  = loadAst.call()
    var right = loadAst.call()
    return makeNode.call(nodeType, left, right)
}

lines = FileUtil.readLines("ast.txt")
lineCount = lines.count
var x = loadAst.call()
interp.call(x)
