import "./dynamic" for Struct
import "./fmt" for Fmt

var NNode = Struct.create("NNode", ["name", "children"])
var INode = Struct.create("INode", ["level", "name"])

var sw = ""

var printNest // recursive
printNest = Fn.new { |n, level|
    if (level == 0) sw = sw + "\n==Nest form==\n\n"
    sw = sw + Fmt.swrite("$0s$s\n", "  " * level, n.name)
    for (c in n.children) {
        sw = sw + ("  " * (level + 1))
        printNest.call(c, level+1)
    }
}

var toNest // recursive
toNest = Fn.new { |iNodes, start, level, n|
    if (level == 0) n.name = iNodes[0].name
    var i = start + 1
    while (i < iNodes.count) {
        if (iNodes[i].level == level + 1) {
            var c = NNode.new(iNodes[i].name, [])
            toNest.call(iNodes, i, level+1, c)
            n.children.add(c)
        } else if (iNodes[i].level <= level) return
        i = i + 1
    }
}

var printIndent = Fn.new { |iNodes|
    sw = sw + "\n==Indent form==\n\n"
    for (n in iNodes) sw = sw + Fmt.swrite("$d $s\n", n.level, n.name)
}

var toIndent // recursive
toIndent = Fn.new { |n, level, iNodes|
    iNodes.add(INode.new(level, n.name))
    for (c in n.children) toIndent.call(c, level+1, iNodes)
}

var n1 = NNode.new("RosettaCode", [])
var n2 = NNode.new("rocks", [NNode.new("code", []), NNode.new("comparison", []), NNode.new("wiki", [])])
var n3 = NNode.new("mocks", [NNode.new("trolling", [])])
n1.children.add(n2)
n1.children.add(n3)

printNest.call(n1, 0)
var s1 = sw
System.print(s1)

var iNodes = []
toIndent.call(n1, 0, iNodes)
sw = ""
printIndent.call(iNodes)
System.print(sw)

var n = NNode.new("", [])
toNest.call(iNodes, 0, 0, n)
sw = ""
printNest.call(n, 0)
var s2 = sw
System.print(s2)

System.print("\nRound trip test satisfied? %(s1 == s2)")
