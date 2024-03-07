import "./seq" for Stack
import "./fmt" for Fmt

var toTree = Fn.new { |list|
    var nested = []
    var s = Stack.new()
    s.push(nested)
    for (n in list) {
        while (n != s.count) {
            if (n > s.count) {
                var inner = []
                s.peek().add(inner)
                s.push(inner)
            } else {
                s.pop()
            }
        }
        s.peek().add(n)
    }
    return nested
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
    var nest = toTree.call(test)
    Fmt.print("$24n => $n", test, nest)
}
