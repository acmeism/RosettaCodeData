// Kotlin Native v0.3

import kotlinx.cinterop.*
import win32.*

fun main(args: Array<String>) {
    val freqs = intArrayOf(262, 294, 330, 349, 392, 440, 494, 523)  // CDEFGABc
    val dur = 500
    repeat(5) { for (freq in freqs) Beep(freq, dur) }
}
