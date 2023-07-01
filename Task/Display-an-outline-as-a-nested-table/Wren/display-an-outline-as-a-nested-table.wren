import "/dynamic" for Struct
import "/fmt" for Fmt

var NNode = Struct.create("NNode", ["name", "children"])
var INode = Struct.create("INode", ["level", "name"])

var toNest // recursive function
toNest = Fn.new { |iNodes, start, level, n|
    if (level == 0) n.name = iNodes[0].name
    var i = start + 1
    while (i < iNodes.count) {
        if (iNodes[i].level == level+1) {
            var c = NNode.new(iNodes[i].name, [])
            toNest.call(iNodes, i, level+1, c)
            n.children.add(c)
        } else if (iNodes[i].level <= level) {
            return
        }
        i = i + 1
    }
}

var makeIndent = Fn.new { |outline, tab|
    var lines = outline.split("\n")
    var iNodes = List.filled(lines.count, null)
    var i = 0
    for (line in lines) {
        var line2 = line.trimStart(" ")
        var le  = line.count
        var le2 = line2.count
        var level = ((le - le2) / tab).floor
        iNodes[i] = INode.new(level, line2)
        i = i + 1
    }
    return iNodes
}

var toMarkup = Fn.new { |n, cols, depth|
    var span = 0
    var colSpan  // recursive closure
    colSpan = Fn.new { |nn|
        var i = 0
        for (c in nn.children) {
            if (i > 0) span = span + 1
            colSpan.call(c)
            i = i + 1
        }
    }

    for (c in n.children) {
        span = 1
        colSpan.call(c)
    }
    var lines = []
    lines.add("{| class=\"wikitable\" style=\"text-align: center;\"")
    var l1 = "|-"
    var l2 = "|  |"
    lines.add(l1)
    span = 1
    colSpan.call(n)
    var s = Fmt.swrite("| style=\"background: $s \" colSpan=$d | $s", cols[0], span, n.name)
    lines.add(s)
    lines.add(l1)

    var nestedFor // recursive function
    nestedFor = Fn.new { |nn, level, maxLevel, col|
        if (level == 1 && maxLevel > level) {
            var i = 0
            for (c in nn.children) {
                nestedFor.call(c, 2, maxLevel, i)
                i = i + 1
            }
        } else if (level < maxLevel) {
            for (c in nn.children) {
                nestedFor.call(c, level+1, maxLevel, col)
            }
        } else {
            if (nn.children.count > 0) {
                var i = 0
                for (c in nn.children) {
                    span = 1
                    colSpan.call(c)
                    var cn = col + 1
                    if (maxLevel == 1) cn = i + 1
                    var s = Fmt.swrite("| style=\"background: $s \" colspan=$d | $s", cols[cn], span, c.name)
                    lines.add(s)
                    i = i + 1
                }
            } else {
                lines.add(l2)
            }
        }
    }
    for (maxLevel in 1...depth) {
        nestedFor.call(n, 1, maxLevel, 0)
        if (maxLevel < depth-1) lines.add(l1)
    }
    lines.add("|}")
    return lines.join("\n")
}

var outline = """
Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.
"""
var yellow = "#ffffe6;"
var orange = "#ffebd2;"
var green  = "#f0fff0;"
var blue   = "#e6ffff;"
var pink   = "#ffeeff;"

var cols = [yellow, orange, green, blue, pink]
var iNodes = makeIndent.call(outline, 4)
var n = NNode.new("", [])
toNest.call(iNodes, 0, 0, n)
System.print(toMarkup.call(n, cols, 4))

System.print("\n")
var outline2 = """
Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
            Propagating the sums upward as necessary.
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.
    Optionally add color to the nodes.
"""
var cols2 = [blue, yellow, orange, green, pink]
var n2 = NNode.new("", [])
var iNodes2 = makeIndent.call(outline2, 4)
toNest.call(iNodes2, 0, 0, n2)
System.print(toMarkup.call(n2, cols2, 4))
