Rebol [
    title: "Rosetta code: Wordiff"
    file:  %Wordiff.r3
    url:   https://rosettacode.org/wiki/Wordiff
]

wordiff-game: function/with [
    words [block!]
][
    wordset: words
    unless all [
        player-a: ask "Player A: what is your name? "
        player-b: ask "Player B: what is your name? "
    ][ exit ]

    ;; Initial random three or four letter word from the dictionary.
    current-word: random/only collect [
        foreach w wordset [ if find [3 4] length? w [keep w] ]
    ]
    print rejoin ["^/The initial word is: " current-word "^/"]
    append clear past-words current-word

    players: reduce [player-a player-b]
    forever [
        answer: ask ajoin [players/1 ": Input a wordiff from '" current-word "': "]
        unless answer [quit]
        trim answer
        either valid-answer? [
            print "Next player..."
            append past-words current-word: answer
            swap players next players
            print ""
        ][  print "^-Try again!"]
    ]

][
    past-words: [] wordset: answer: current-word: players: none
    levenshtein: function [
        ;; Returns the Levenshtein distance between two strings.
        s1 [string!] s2 [string!]
    ][
        if s1 = s2   [return 0]
        if empty? s1 [return length? s2]
        if empty? s2 [return length? s1]
        if (length? s1) < length? s2 [set [s1 s2] reduce [s2 s1]]
        m: length? s1 n: length? s2
        row: append clear [] 0
        repeat j n [append row j]
        repeat i m [
            prev: row/1
            row/1: i
            repeat j n [
                save: row/(j + 1)
                row/(j + 1): min min
                    row/:j + 1
                    row/(j + 1) + 1
                    prev + pick [0 1] s1/:i = s2/:j
                prev: save
            ]
        ]
        row/(n + 1)
    ]
    valid-answer?: func [
        ;; Validate the player's proposed next word.
    ][
        case [
            not find wordset answer [
                print "^-Not a valid dictionary word."
                false
            ]
            did find past-words answer [
                print "^-Word already used."
                false
            ]
            1 != levenshtein answer current-word [
                print "^-Not a correct worddiff."
                print ["You have lost the game, " players/1]
                quit
            ]
            true
        ]
    ]
]

wordiff-game read/lines %unixdict.txt
