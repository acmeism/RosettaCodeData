# syntax: GAWK -f METRONOME.AWK
@load "time"
BEGIN {
    metronome(120,6,10)
    metronome(72,4)
    exit(0)
}
function metronome(beats_per_min,beats_per_bar,limit,  beats,delay,errors) {
    print("")
    if (beats_per_min+0 <= 0) { print("error: beats per minute is invalid") ; errors++ }
    if (beats_per_bar+0 <= 0) { print("error: beats per bar is invalid") ; errors++ }
    if (limit+0 <= 0) { limit = 999999 }
    if (errors > 0) { return }
    delay = 60 / beats_per_min
    printf("delay=%f",delay)
    while (beats < limit) {
      printf((beats++ % beats_per_bar == 0) ? "\nTICK" : " tick")
      sleep(delay)
    }
}
