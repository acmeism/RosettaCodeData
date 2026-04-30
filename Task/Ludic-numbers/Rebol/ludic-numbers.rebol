Rebol [
    title: "Rosetta code: Ludic numbers"
    file:  %Ludic_numbers.r3
    url:   https://rosettacode.org/wiki/Ludic_numbers
]

;; A ludic number is derived by repeatedly sieving a list using each found ludic number
;; as the step size — similar in spirit to the Sieve of Eratosthenes for primes.
ludic-numbers: function [
    "Generates ludic numbers up to a maximum value using the ludic sieve algorithm."
    nmax [integer!]   "Upper bound — generates candidates from 2 to nmax+1"
][
    result: copy [1]  ;; 1 is always the first ludic number by definition
    block: clear []   ;; Candidate list to be sieved
    repeat n nmax [append block n + 1]  ;; Populate with integers 2 to nmax+1

    i: 0  ;; Current position in the candidate list (0-based index)

    while [ i < length? block ] [       ;; Iterate until all candidates are processed
        item: pickz block i             ;; Pick the next ludic number at position i
        append result item              ;; It survives the sieve, so add it to results
        ;; Sieve out every item-th element from the candidate list,
        ;; starting at position 0 (the first remaining candidate)
        del: 0                          ;; Start sieving from index 0
        while [del < length? block] [
            remove atz block del        ;; Remove the element at the current sieve position
            del: del - 1 + item         ;; Advance by item steps, correcting for the removal
        ]
        ;; Note: i is NOT incremented here — after sieving, the next candidate
        ;; has shifted into position i automatically due to the removals
    ]
    result  ;; Return the list of ludic numbers found
]

ludics: ludic-numbers 25000
le-than-1000: []
foreach x ludics [
    either x <= 1000 [ append le-than-1000 x ][ break ]
]
print ["First 25:"          copy/part ludics 25]
print ["Ludics below 1000:" length? le-than-1000]
print ["Ludic 2000 to 2005:" copy/part skip ludics 1999 6]
prin   "Triples below 250:"
foreach x ludics [
    if x >= 250 [ break ]
    if all [
        find ludics x + 2
        find ludics x + 6
    ][
        prin ajoin [" (" x SP x + 2 SP x + 6 ")"]
    ]
]
print LF
