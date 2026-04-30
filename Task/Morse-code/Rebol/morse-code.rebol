Rebol [
    title: "Rosetta code: Morse code"
    file:  %Morse_code.r3
    url:   https://rosettacode.org/wiki/Morse_code
]

play-morse: function/with [
    "Play Morse code"
    text [string!]
][
    foreach line split-lines text [
        print rejoin ["^/Transmitting: " line "^/"]
        foreach c line [
            code: select morse-map c
            either code [
                prin [c ": "]
                foreach sym code [
                    prin sym
                    either sym = #"." [dot][dash]
                ]
                print ""
                wait 0.3
            ][
                if c = #" " [
                    print "[word gap]"
                    wait 0.3
                ]
            ]
        ]
    ]
    print "^/Done."
][
    ;; Morse code dictionary
    morse-map: #[
        #"A" ".-"    #"B" "-..."  #"C" "-.-."  #"D" "-.."
        #"E" "."     #"F" "..-."  #"G" "--."   #"H" "...."
        #"I" ".."    #"J" ".---"  #"K" "-.-"   #"L" ".-.."
        #"M" "--"    #"N" "-."    #"O" "---"   #"P" ".--."
        #"Q" "--.-"  #"R" ".-."   #"S" "..."   #"T" "-"
        #"U" "..-"   #"V" "...-"  #"W" ".--"   #"X" "-..-"
        #"Y" "-.--"  #"Z" "--.."
        #"0" "-----" #"1" ".----" #"2" "..---" #"3" "...--"
        #"4" "....-" #"5" "....." #"6" "-...." #"7" "--..."
        #"8" "---.." #"9" "----."
    ]
    ;-- Sound functions...
    ;@@ https://github.com/Oldes/Rebol-MiniAudio
    audio: import 'miniaudio
    with audio [
        ;; initialize an audio device...
        device: init-playback 1
        ;; create a waveform
        wave: make-waveform-node type_sine 0.5 500.0
        ;; start the sound to be reused for the beep (paused)
        stop snd: play :wave
        ;; beep function accepting time how long
        beep: function[time [decimal! time!]][
            start :snd
            wait time
            stop :snd
            wait 0.1
        ]
        dot:  does[beep 0.1]
        dash: does[beep 0.3]
    ]
]

play-morse "SOS, Hello Rebol!"
