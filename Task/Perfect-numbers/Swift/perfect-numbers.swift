func perfect(n:Int) -> Bool {
    var sum = 0
    for i in 1..<n {
        if n % i == 0 {
            sum += i
        }
    }
    return sum == n
}

for i in 1..<10000 {
    if perfect(i) {
        println(i)
    }
}
