|i j k  d n n0 t|
i := 2.
j := 2 sqrt floor.
k := j.
d := j.
Stdout nextPutAll:'Number of digits: '.
n := n0 := Integer readFrom:Stdin onError:[ 'bad input' printCR. ^ self].
t := Time millisecondsToRun:[
    [
        Stdout print:d.
        i := (i - (k * d)) * 100.
        k := 20 * j.
        d := 1.
        [:exit |
            [d <= 10] whileTrue:[
                ((k + d) * d) > i ifTrue:[
                    d := d - 1.
                    exit value.
                ].
                d := d + 1.
            ].
        ] valueWithExit.
        j := (j * 10) + d.
        k := k + d.
        n := n-1.
    ] doWhile:[n > 0].
].
Stdout print: e'\nTime taken for {n0} digits: {t}ms\n'.
