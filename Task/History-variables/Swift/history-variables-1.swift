var historyOfHistory = [Int]()
var history:Int = 0 {
    willSet {
        historyOfHistory.append(history)
    }
}

history = 2
history = 3
history = 4
println(historyOfHistory)
