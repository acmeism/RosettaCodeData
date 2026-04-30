Rebol [
    title: "Rosetta code: Bulls and cows player"
    file:  %Bulls_and_cows-player.r3
    url:   https://rosettacode.org/wiki/Bulls_and_cows/Player
    needs: 3.15.0 ;; or something like that
    note:  "Based on Red language solution"
]

bulls-and-cows-player: function/with [
    "Bulls and cows game player"
    secret
][
    secret: form secret
    while [
        not valid secret
    ][  secret: ask "^/Enter Number with 4 uniq digits (1-9 only) " ]
    ;; reset results map
    clear results
    ;; iterate all candidate guesses consistent with previous feedback
    foreach guess possible [
        ;; cross-check candidate against all prior guess->result constraints
        foreach [k v] results [
            if v <> check guess k [guess: copy "" break]
        ]
        ;; skip candidate if it violated any constraint
        if empty? guess [continue]
        ;; evaluate feedback (bulls/cows) for this guess against the secret and store it
        results/:guess: res: check guess secret
        ;; stop searching when four bulls achieved
        if res == "BBBB" [break]
    ]
    ;; display guess history and their feedback
    foreach [k v] results [print [k "-" v]]
    ;; summary: found number and number of attempts
    print ["^/Found" as-yellow last k: keys-of results "in" as-yellow length? k "attempts" CR]
][
    secret: none
    digits: charset "0123456789" ;; character set of digits for parse rule
    results: make map! []        ;; map of guess -> feedback string (e.g., "BBC")

    check: function [
        "compute bulls and cows feedback for a guess vs. a secret"
        guess secret
    ][
        sort append copy "" collect [
            repeat pos 4 [
                either guess/:pos == secret/:pos [
                    keep #"B"
                ][
                    if find secret guess/:pos [keep #"C"]
                ]
            ]
        ]
    ]
    valid: function [
        "validate a guess: exactly 4 digits and all unique"
        guess
    ][
        all [
            parse guess [4 digits]
            4 == length? unique guess
        ]
    ]
    ;; precompute all valid 4-unique-digit numbers as candidate guesses
    possible: collect [
        repeat i 9876 [
            if valid secret: to string! i [keep secret]
        ]
    ]
]

;; DEMO:
bulls-and-cows-player 1543
