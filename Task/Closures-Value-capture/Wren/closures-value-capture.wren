var fs = List.filled(10, null)
for (i in 0...fs.count) {
    fs[i] = Fn.new { i * i }
}

for (i in 0...fs.count-1) System.print("Function #%(i):  %(fs[i].call())")
