import "./sort" for Sort
import "./fmt" for Fmt

var sortedOutline = Fn.new { |originalOutline, ascending|
    var outline = originalOutline.toList // make copy in case we mutate it
    var indent = ""
    var del = "\x7f"
    var sep = "\0"
    var messages = []
    if (outline[0].trimStart(" \t") != outline[0]) {
        System.print("    outline structure is unclear")
        return
    }
    for (i in 1...outline.count) {
        var line = outline[i]
        var lc = line.count
        if (line.startsWith("  ") || line.startsWith(" \t") || line.startsWith("\t")) {
            var lc2 = line.trimStart(" \t").count
            var currIndent = line[0...lc-lc2]
            if (indent == "") {
                indent = currIndent
            } else {
                var correctionNeeded = false
                if ((currIndent.contains("\t") && !indent.contains("\t")) ||
                    (!currIndent.contains("\t") && indent.contains("\t"))) {
                    messages.add(indent + "corrected inconsistent whitespace use at line '%(line)'")
                    correctionNeeded = true
                } else if (currIndent.count % indent.count != 0) {
                    messages.add(indent + "corrected inconsistent indent width at line '%(line)'")
                    correctionNeeded = true
                }
                if (correctionNeeded) {
                    var mult = (currIndent.count / indent.count).round
                    outline[i] = (indent * mult) + line[lc-lc2..-1]
                }
            }
        }
    }
    var levels = List.filled(outline.count, 0)
    levels[0] = 1
    var level = 1
    var margin = ""
    while (!levels.all { |l| l > 0 }) {
        var mc = margin.count
        for (i in 1...outline.count) {
            if (levels[i] == 0) {
                var line = outline[i]
                if (line.startsWith(margin) && line[mc] != " " && line[mc] != "\t") levels[i] = level
            }
        }
        margin = margin + indent
        level = level + 1
    }
    var lines = List.filled(outline.count, "")
    lines[0] = outline[0]
    var nodes = []
    for (i in 1...outline.count) {
        if (levels[i] > levels[i-1]) {
            nodes.add((nodes.count == 0) ? outline[i - 1] : sep + outline[i-1])
        } else if (levels[i] < levels[i-1]) {
            var j = levels[i-1] - levels[i]
            for (k in 1..j) nodes.removeAt(-1)
        }
        if (nodes.count > 0) {
            lines[i] = nodes.join() + sep + outline[i]
        } else {
            lines[i] = outline[i]
        }
    }
    if (ascending) {
        Sort.insertion(lines)
    } else {
        var maxLen = lines.reduce(0) { |max, l| (l.count > max) ? l.count : max }
        for (i in 0...lines.count) lines[i] = Fmt.ljust(maxLen, lines[i], del)
        Sort.insertion(lines, true)
    }
    for (i in 0...lines.count) {
        var s = lines[i].split(sep)
        lines[i] = s[-1]
        if (!ascending) lines[i] = lines[i].trimEnd(del)
    }
    if (messages.count > 0) {
        System.print(messages.join("\n"))
        System.print()
    }
    System.print(lines.join("\n"))
}

var outline = [
    "zeta",
    "    beta",
    "    gamma",
    "        lambda",
    "        kappa",
    "        mu",
    "    delta",
    "alpha",
    "    theta",
    "    iota",
    "    epsilon"
]

var outline2 = outline.map { |s| s.replace("    ", "\t") }.toList

var outline3 = [
    "alpha",
    "    epsilon",
	"        iota",
    "    theta",
    "zeta",
    "    beta",
    "    delta",
    "    gamma",
    "    \t   kappa", // same length but \t instead of space
    "        lambda",
    "        mu"
]

var outline4 = [
    "zeta",
    "    beta",
    "   gamma",
    "        lambda",
    "         kappa",
    "        mu",
    "    delta",
    "alpha",
    "    theta",
    "    iota",
    "    epsilon"
]

System.print("Four space indented outline, ascending sort:")
sortedOutline.call(outline, true)

System.print("\nFour space indented outline, descending sort:")
sortedOutline.call(outline, false)

System.print("\nTab indented outline, ascending sort:")
sortedOutline.call(outline2, true)

System.print("\nTab indented outline, descending sort:")
sortedOutline.call(outline2, false)

System.print("\nFirst unspecified outline, ascending sort:")
sortedOutline.call(outline3, true)

System.print("\nFirst unspecified outline, descending sort:")
sortedOutline.call(outline3, false)

System.print("\nSecond unspecified outline, ascending sort:")
sortedOutline.call(outline4, true)

System.print("\nSecond unspecified outline, descending sort:")
sortedOutline.call(outline4, false)
