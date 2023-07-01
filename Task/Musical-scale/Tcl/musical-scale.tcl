package require sound

# Encapsulate the tone generation
set filter [snack::filter generator 1 20000 0.5 sine -1]
set sound  [snack::sound -rate 22050]
proc play {frequency length} {
    global filter sound

    $filter configure $frequency
    $sound play -filter $filter

    # Need to run event loop; Snack uses it internally
    after $length {set donePlay 1}
    vwait donePlay

    $sound stop
}

# Major scale up, then down; extra delay at ends of scale
set tonicFrequency 261.63; # C4
foreach i {0 2 4 5 7 9 11 12 11 9 7 5 4 2 0} {
    play [expr {$tonicFrequency*2**($i/12.0)}] [expr {$i%12?250:500}]
}
