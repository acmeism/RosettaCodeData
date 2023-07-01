import "timer" for Timer
import "io" for Stdout

var metronome = Fn.new { |bpm, bpb, maxBeats|
    var delay = (60000/bpm).floor
    var beats = 0
    while (true) {
        Timer.sleep(delay)
        System.write((beats % bpb == 0) ? "\n\aTICK " : "\atick ")
        Stdout.flush()
        beats = beats + 1
        if (beats == maxBeats) break
    }
    System.print()
}

metronome.call(120, 4, 20) // limit to 20 beats
