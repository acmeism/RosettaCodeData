import "/fmt" for Fmt

var wants = [
    ["map", 9, 150],
    ["compass", 13, 35],
    ["water", 153, 200],
    ["sandwich", 50, 160],
    ["glucose", 15, 60],
    ["tin", 68, 45],
    ["banana", 27, 60],
    ["apple", 39, 40],
    ["cheese", 23, 30],
    ["beer", 52, 10],
    ["suntan cream", 11, 70],
    ["camera", 32, 30],
    ["T-shirt", 24, 15],
    ["trousers", 48, 10],
    ["umbrella", 73, 40],
    ["waterproof trousers", 42, 70],
    ["waterproof overclothes", 43, 75],
    ["note-case", 22, 80],
    ["sunglasses", 7, 20],
    ["towel", 18, 12],
    ["socks", 4, 50],
    ["book", 30, 10]
]

var m
m = Fn.new { |i, w|
    if (i < 0 || w == 0) return [[], 0, 0]
    if (wants[i][1] > w) return m.call(i-1, w)
    System.write("") // guard against VM recursion bug
    var res = m.call(i-1, w)
    var i0 = res[0]
    var w0 = res[1]
    var v0 = res[2]
    res = m.call(i-1, w - wants[i][1])
    var i1 = res[0]
    var w1 = res[1]
    var v1 = res[2] + wants[i][2]
    if (v1 > v0) {
        i1.add(wants[i])
        return [i1, w1 + wants[i][1], v1]
    }
    return [i0, w0, v0]
}

var maxWt = 400
var res = m.call(wants.count-1, maxWt)
var items = res[0]
var tw = res[1]
var tv = res[2]
System.print("Max weight: %(maxWt)\n")
System.print("Item                  Weight   Value")
System.print("------------------------------------")
for (i in 0...items.count) {
    Fmt.print("$-22s  $3d     $4s", items[i][0], items[i][1], items[i][2])
}
System.print("                        ---     ----")
Fmt.print("totals                  $3d     $4d", tw, tv)
