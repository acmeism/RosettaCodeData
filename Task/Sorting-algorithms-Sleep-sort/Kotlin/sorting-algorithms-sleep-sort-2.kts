import kotlinx.coroutines.*

fun sleepSort(list: List<Int>, delta: Long) {
    runBlocking {
        list.onEach {
            launch {
                delay(it * delta)
                print("$it ")
            }
        }
    }
}

fun main() {
    val list = listOf(5, 7, 2, 4, 1, 8, 0, 3, 9, 6)
    println("Unsorted: ${list.joinToString(" ")}")
    print("Sorted  : ")
    sleepSort(list, 10)
}
