package require sound

set baseFrequency 261.63
set baseAmplitude [expr {64000 / 100.0}]
set halfSemis 0
set volSteps 10

# How to adjust the generator
proc adjustPitchVolume {changePitch changeVolume} {
    global filter baseFrequency baseAmplitude halfSemis volSteps
    incr halfSemis $changePitch
    incr volSteps $changeVolume
    # Clamp the volume range
    set volSteps [expr {$volSteps < 0 ? 0 : $volSteps > 10 ? 10 : $volSteps}]
    puts -nonewline " Pitch: [expr {$halfSemis / 2.0}]  Volume: $volSteps  \r"
    set freq [expr {$baseFrequency * 2**($halfSemis/24.0)}]
    set ampl [expr {$baseAmplitude * $volSteps**2}]

    # This is where we set the actual frequency of the generated sound
    $filter configure $freq $ampl
}

# Callback handler for pressed keys
proc keyPress {} {
    global done
    switch [string tolower [read stdin 1]] {
    "q" { set done 1 }
    "u" { adjustPitchVolume 1 0 }
    "d" { adjustPitchVolume -1 0 }
    "s" { adjustPitchVolume 0 -1 }
    "l" { adjustPitchVolume 0 1 }
    default {
        if {[eof stdin]} { set done 1 }
    }
    }
}

# Instantiate the sound generation objects from the Snack library
set filter [snack::filter generator 1 32000 0.5 sine -1]
set sound [snack::sound -rate 32050]

# Make things ready for a console application
exec stty raw -echo <@stdin >@stdout
fconfigure stdout -buffering none
fileevent stdin readable keyPress
puts "'U' to raise pitch, 'D' to lower pitch, 'L' for louder, 'S' for softer"
puts "'Q' to quit"

# Start the playing
$sound play -filter $filter
adjustPitchVolume 0 0

# Wait until the user is finished
vwait done

# Clean up the console from its non-standard state
fileevent stdin readable {}
puts ""
exec stty -raw echo <@stdin >@stdout

# Stop the sound playing
$sound stop
exit
