proc seq_lookandsay {n {coroName next_lookandsay}} {
    coroutine $coroName apply {n {
        for {} {[yield $n] ne "stop"} {set n $new} {
            set new ""
            foreach subseq [regexp -all -inline {0+|1+|2+|3+|4+|5+|6+|7+|8+|9+} $n] {
                append new [string length $subseq] [string index $subseq 0]
            }
        }
    }} $n
}

puts [seq_lookandsay 1]
puts [next_lookandsay]
puts [next_lookandsay]
puts [next_lookandsay]
puts [next_lookandsay]
puts [next_lookandsay]
puts [next_lookandsay]
puts [next_lookandsay]
puts [next_lookandsay]
puts [next_lookandsay]
