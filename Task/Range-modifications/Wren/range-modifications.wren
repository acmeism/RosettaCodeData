import "./fmt" for Fmt

var rangesAdd = Fn.new { |ranges, n|
    if (ranges.count == 0) {
        ranges.add(n..n)
        return
    }
    for (i in 0...ranges.count) {
        var r = ranges[i]
        if (n < r.from - 1) {
            ranges.insert(i, n..n)
            return
        } else if (n == r.from-1) {
            ranges[i] = n..r.to
            return
        } else if (n <= r.to) {
            return
        } else if (n == r.to+1) {
            ranges[i] = r.from..n
            if (i < ranges.count - 1 && (n == ranges[i+1].from || n + 1 == ranges[i+1].from)) {
                ranges[i] = r.from..ranges[i+1].to
                ranges.removeAt(i+1)
            }
            return
        } else if (i == ranges.count - 1) {
            ranges.add(n..n)
            return
        }
    }
}

var rangesRemove = Fn.new { |ranges, n|
    if (ranges.count == 0) return
    for (i in 0...ranges.count) {
        var r = ranges[i]
        if (n <= r.from - 1) {
            return
        } else if (n == r.from && n == r.to) {
            ranges.removeAt(i)
            return
        } else if (n == r.from) {
            ranges[i] = n+1..r.to
            return
        } else if (n < r.to) {
            ranges[i] = r.from..n-1
            ranges.insert(i+1, n+1..r.to)
            return
        } else if (n == r.to) {
            ranges[i] = r.from..n-1
            return
        }
    }
}

var standard = Fn.new { |ranges| Fmt.v("s", 0, ranges, 0, ",", "").replace("..", "-") }

var add = 0
var remove = 1
var fns = [
    Fn.new { |ranges, n|
        rangesAdd.call(ranges, n)
        Fmt.print("       add $2d => $n", n, standard.call(ranges))
    },
    Fn.new { |ranges, n|
        rangesRemove.call(ranges, n)
        Fmt.print("    remove $2d => $n", n, standard.call(ranges))
    }
]

var ranges = []
var ops = [ [add, 77], [add, 79], [add, 78], [remove, 77], [remove, 78], [remove, 79] ]
Fmt.print("Start: $q", standard.call(ranges))
for (op in ops) fns[op[0]].call(ranges, op[1])

ranges = [1..3, 5..5]
ops = [ [add, 1], [remove, 4], [add, 7], [add, 8], [add, 6], [remove, 7] ]
Fmt.print("\nStart: $q", standard.call(ranges))
for (op in ops) fns[op[0]].call(ranges, op[1])

ranges = [1..5, 10..25, 27..30]
ops = [ [add, 26], [add, 9], [add, 7], [remove, 26], [remove, 9], [remove, 7] ]
Fmt.print("\nStart: $q", standard.call(ranges))
for (op in ops) fns[op[0]].call(ranges, op[1])
