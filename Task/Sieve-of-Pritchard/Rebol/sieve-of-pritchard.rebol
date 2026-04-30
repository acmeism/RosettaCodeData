Rebol [
    title: "Rosetta code: Sieve of Pritchard"
    file:  %Sieve_of_Pritchard.r3
    url:   https://rosettacode.org/wiki/Sieve_of_Pritchard
    note:  "Translated from Python which was translated from Julia"
]

pritchard: function [
    "Pritchard sieve: finds all primes up to `limit` using a wheel-based sieve."
    limit [integer!]
][
    primes: copy []       ;; Accumulates primes found so far (before final sweep)
    steplength: 1         ;; Current length/period of the wheel
    prime:      2         ;; Current prime being used to cull the wheel
    nlimit:     2         ;; Current upper bound of active wheel members
    rtlim: to integer! square-root limit  ;; Only need primes up to sqrt(limit)

    ;; Use a bitset as a memory-efficient boolean membership array.
    ;; Index i is true if i is currently in the "wheel" (candidate set).
    members: make bitset! limit + 1
    members/1: true       ;; The wheel always starts with 1 as a member

    ;; Main loop: extend the wheel and cull composites for each prime <= sqrt(limit)
    while [prime <= rtlim][
        ;; --- Phase 1: Extend the wheel up to nlimit ---
        ;; If the wheel hasn't yet reached the limit, grow it by repeating
        ;; its current members shifted by multiples of steplength.
        if steplength < limit [
            for w 1 limit 1 [
                if members/:w [              ;; For each current wheel member w...
                    n: w + steplength
                    while [n <= nlimit][
                        members/:n: true     ;; ...add w + k*steplength to the wheel
                        n: n + steplength
                    ]
                ]
            ]
            steplength: nlimit  ;; The wheel period is now nlimit
        ]
        ;; --- Phase 2: Cull multiples of `prime` from the wheel ---
        ;; Snapshot the wheel before culling so we iterate a stable set.
        np: 5    ;; Sentinel: will hold the next prime candidate after `prime`
        mcpy: copy members
        for w 1 limit 1 [
            if mcpy/:w [                          ;; For each member w in the snapshot...
                if all [np = 5  w > prime][np: w] ;; Track the first member > prime as next prime
                n: prime * w                      ;; prime * w is composite, remove it
                if n > nlimit [break]             ;; Multiples beyond nlimit can't be members
                members/:n: false                 ;; Cull the composite from the live wheel
            ]
        ]
        ;; If no next-prime candidate was found beyond `prime`, we're done early
        if np < prime [break]
        ;; Commit current prime to the results list
        append primes prime
        ;; Advance to the next prime:
        ;; 2's successor in the wheel is always 3 otherwise use the tracked candidate
        prime: either prime = 2 [3][np]
        nlimit: min (steplength * prime) limit  ;; Extend wheel up to next prime's reach
    ]
    ;; --- Final sweep: collect all remaining wheel members as primes ---
    ;; Any member still in the wheel at index >= 2 is prime.
    for i 2 limit 1 [
        if members/:i [append primes i]
    ]
    ;; Return sorted
    sort primes
]

print pritchard 150
print rejoin ["Number of primes up to 1'000'000: " length? pritchard 1'000'000]
