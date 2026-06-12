#! /usr/bin/env stx --script
(pid := OperatingSystem fork) == 0 ifTrue:[
    Stdin close.
    Stdout := '/tmp/daemon.log' asFilename writeStream.
    Stdout buffered:false. "so we can watch it growing"
    Transcript := Stderr := Stdout.

    Stdout showCR: e'here is the child'.
    1 to:5 do:[:n |
        Delay waitForSeconds:5.
        Transcript showCR: e'another hello on Transcript {n}'.
    ].
] ifFalse:[
    Stdout showCR: e'forked new process pid={pid}; now exiting'.
    OperatingSystem exit:0
]
