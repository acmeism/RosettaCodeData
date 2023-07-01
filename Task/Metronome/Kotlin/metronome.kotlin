// version 1.1.2

fun metronome(bpm: Int, bpb: Int, maxBeats: Int = Int.MAX_VALUE) {
    val delay = 60_000L / bpm
    var beats = 0
    do {
        Thread.sleep(delay)
        if (beats % bpb == 0) print("\nTICK ")
        else print("tick ")
        beats++
    }
    while (beats < maxBeats)
    println()
}

fun main(args: Array<String>) = metronome(120, 4, 20) // limit to 20 beats
