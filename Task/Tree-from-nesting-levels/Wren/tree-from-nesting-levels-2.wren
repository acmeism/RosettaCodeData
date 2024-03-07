import "./fmt" for Fmt

var toTree // recursive
toTree = Fn.new { |list, index, depth|
    var soFar = []
    while (index < list.count) {
        var t = list[index]
        if (t == depth) {
            soFar.add(t)
        } else if (t > depth) {
            var n = toTree.call(list, index, depth+1)
            index = n[0]
            soFar.add(n[1])
        } else {
            index = index - 1
            break
        }
        index = index + 1
    }
    if (depth > 1) return [index, soFar]
    return [-1, soFar]
}

var tests = [
    [],
    [1, 2, 4],
    [3, 1, 3, 1],
    [1, 2, 3, 1],
    [3, 2, 1, 3],
    [3, 3, 3, 1, 1, 3, 3, 3]
]
for (test in tests) {
    var n = toTree.call(test, 0, 1)
    Fmt.print("$24n => $n", test, n[1])
}
