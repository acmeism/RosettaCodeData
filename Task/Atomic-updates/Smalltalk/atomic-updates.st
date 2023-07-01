NUM_BUCKETS := 10.
"create and preset with random data"
buckets := (1 to:NUM_BUCKETS)
             collect:[:i | Random nextIntegerBetween:0 and:10000]
             as:Array.
count_randomizations := 0.
count_equalizations := 0.

printSum :=
    [
        "the sum must be computed and printed while noone fiddles around"
        |snapshot|
        snapshot := buckets synchronized:[ buckets copy ].
        Transcript showCR: e' {snapshot} sum={snapshot sum}'.
    ].

pickTwo :=
    [:action |
        "pick two pockets and eval action on it"
        |p1 p2|
        p1 := Random nextIntegerBetween:1 and:NUM_BUCKETS.
        p2 := Random nextIntegerBetween:1 and:NUM_BUCKETS.
        buckets synchronized:[ action value:p1 value:p2 ].
    ].

randomize :=
    [
        pickTwo value:[:p1 :p2 |
            "take a random value from p1 and add to p2"
            |howMuch|
            howMuch := Random nextIntegerBetween:0 and:(buckets at:p1).
            buckets at:p1 put:(buckets at:p1)-howMuch.
            buckets at:p2 put:(buckets at:p2)+howMuch.
        ].
        count_randomizations := count_randomizations + 1.
    ].

equalize :=
    [
        pickTwo value:[:p1 :p2 |
            "average them"
            |diff|
            diff := ((buckets at:p1) - (buckets at:p2)) // 2.
            buckets at:p1 put:(buckets at:p1)-diff.
            buckets at:p2 put:(buckets at:p2)+diff.
        ].
        count_equalizations := count_equalizations + 1.
    ].

"start the show"
randomizer := [ randomize loop ] fork.
equalizer  := [ equalize loop ] fork.

"every 2 seconds, print the sum"
monitor    := [
                [
                    printSum value.
                    Delay waitFor:2 seconds.
                ] loop.
              ] fork.

"let it run for 10 seconds, then kill them all"
Delay waitFor:20 seconds.
randomizer terminate.
equalizer terminate.
monitor terminate.

Stdout printCR: e'performed {count_equalizations} equalizations and {count_randomizations} randomizations'.
