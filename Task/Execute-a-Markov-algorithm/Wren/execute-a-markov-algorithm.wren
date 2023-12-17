import "./ioutil" for FileUtil, File
import "./pattern" for Pattern

var lb = FileUtil.lineBreak

/* rulesets assumed to be separated by a blank line in file */
var readRules = Fn.new { |path|
    return File.read(path).trimEnd().split("%(lb)%(lb)").map { |rs| rs.split(lb) }.toList
}

/* tests assumed to be on consecutive lines */
var readTests = Fn.new { |path| File.read(path).trimEnd().split(lb) }

var rules = readRules.call("markov_rules.txt")
var tests = readTests.call("markov_tests.txt")
var pattern = Pattern.new("+0/s[~.][+0/z]", Pattern.start)
var ix = 0
for (origTest in tests) {
    var captures = []
    for (rule in rules[ix]) {
        if (rule.startsWith("#")) continue
        var splits = rule.split(" -> ")
        var m = pattern.find(splits[1])
        if (m) captures.add([splits[0].trimEnd()] + m.capsText)
    }
    var test = origTest
    while (true) {
        var copy = test
        var redo = false
        for (c in captures) {
            test = test.replace(c[0], c[2])
            if (c[1] == ".") break
            if (test != copy) {
                redo = true
                break
            }
        }
        if (!redo) break
    }
    System.print("%(origTest)\n%(test)\n")
    ix = ix + 1
}
