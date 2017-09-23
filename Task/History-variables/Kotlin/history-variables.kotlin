// version 1.1.4

class HistoryVariable<T>(initialValue: T) {
    private val history = mutableListOf<T>()

    var currentValue: T
        get() = history[history.size - 1]
        set(value) {
           history.add(value)
        }

    init {
        currentValue = initialValue
    }

    fun showHistory() {
        println("The variable's history, oldest values first, is:")
        for (item in history) println(item)
    }
}

fun main(args: Array<String>) {
    val v = HistoryVariable(1)
    v.currentValue = 2
    v.currentValue = 3
    v.showHistory()
    println("\nCurrentvalue is ${v.currentValue}")
}
