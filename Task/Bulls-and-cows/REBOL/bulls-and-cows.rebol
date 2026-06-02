Rebol [
    title: "Rosetta code: Bulls and cows"
    file:  %Bulls_and_cows.r3
    url:   https://rosettacode.org/wiki/Bulls_and_cows
    needs: 3.10.0 ;; or something like that
    note:  "Based on Red language solution"
]

bulls-and-cows: function/with [
    "Bulls and cows game"
    /seed   "optional refinement to provide a custom RNG seed"
     value
][
    ;; Initialize RNG seed: use provided value, otherwise current time
    random/seed any [value now/time]
    ;; Secret 4-digit number with (implicitly) distinct digits from a random permutation
    number: copy/part random numbers 4
    guesses: 0
    ;; Main game loop: continue until all 4 digits are correct and in correct positions
    while [bulls <> 4] [
        bulls: cows: 0        ;; reset counters for this round
        ;; Read user's guess
        unless guess: ask "Make a guess: " [return none] ;; none on CTRL+C
        ;; Validate: exactly 4 digits (note: does not enforce distinctness here)
        unless parse guess [4 digits] [
            print "Guess should include exactly four different digits!"
            continue
        ]
        ++ guesses
        ;; Count bulls: correct digit in the correct position
        repeat i 4 [
            if guess/:i == number/:i [++ bulls]
        ]
        ;; Count cows: correct digits in any position, minus the bulls
        cows: (length? intersect guess number) - bulls
        print ["bulls: " bulls " cows: " cows]
    ]
    print ["You won after" guesses "guesses!"]
][
    ;; WITH body: shared environment for the function
    numbers: "0123456789"     ;; pool of digits for generating the secret number
    digits: charset numbers   ;; character set used by the parser rule [4 digits]
    bulls: cows: guesses: 0   ;; initialize counters
]

;; DEMO:
bulls-and-cows/seed 1
