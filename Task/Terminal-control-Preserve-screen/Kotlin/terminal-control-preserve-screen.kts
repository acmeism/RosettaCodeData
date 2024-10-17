// version 1.1.2

const val ESC = "\u001B"

fun main(args: Array<String>) {
    print("$ESC[?1049h$ESC[H")
    println("Alternate screen buffer")
    for(i in 5 downTo 1) {
        print("\rGoing back in $i second${if (i != 1) "s" else ""}...")
        Thread.sleep(1000)
    }
    print("$ESC[?1049l")
}
