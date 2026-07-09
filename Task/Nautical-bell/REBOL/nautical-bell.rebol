Rebol [
    title: "Rosetta code: Nautical bell"
    file:  %Nautical_bell.r3
    url:   https://rosettacode.org/wiki/Nautical_bell
]

forever [
    now-time: now/time

    ;; seconds until next half-hour mark
    wait (29 - (now-time/minute % 30)) * 60 + 60 - now-time/second

    prin format [<yyyy-mm-dd hh:mm> " | "] now-time: now/time

    ;; Bells...
    if zero? n: (now-time/hour * 2 + (now-time/minute / 30)) % 8 [n: 8]
    loop n / 2 [prin "^Gbang"  wait 2  prin "-bang ^G"  wait 2]
    if odd? n  [prin "^Gbang"]
    print ""
]
