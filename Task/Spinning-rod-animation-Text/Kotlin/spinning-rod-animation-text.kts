// Version 1.2.50

const val ESC = "\u001b"

fun main(args: Array<String>) {
    val a = "|/-\\"
    print("$ESC[?25l") // hide the cursor
    val start = System.currentTimeMillis()
    while (true) {
        for (i in 0..3) {
            print("$ESC[2J")       // clear terminal
            print("$ESC[0;0H")     // place cursor at top left corner
            for (j in 0..79) {     // 80 character terminal width, say
                print(a[i])
            }
            Thread.sleep(250)
        }
        val now = System.currentTimeMillis()
        // stop after 20 seconds, say
        if (now - start >= 20000) break
    }
    print("$ESC[?25h") // restore the cursor
}
