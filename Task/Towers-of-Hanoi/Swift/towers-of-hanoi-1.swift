func hanoi(n:Int, a:String, b:String, c:String) {
    if (n > 0) {
        hanoi(n - 1, a, c, b)
        println("Move disk from \(a) to \(c)")
        hanoi(n - 1, b, a, c)
    }
}

hanoi(4, "A", "B", "C")
