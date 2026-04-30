Rebol [
	title: "Rosetta code: 100 prisoners"
	file: %100_prisoners.r3
	url: https://rosettacode.org/wiki/100_prisoners
	needs: 3.0.0
    note: "Based on Red language implementation!"
]

random/seed 1
prisoners: 100                     ;; Total number of prisoners in the puzzle
K_runs: 10000                      ;; Number of simulation runs to perform

rand_arr: make block! prisoners         ;; Will hold the numbers 1..100
repeat n prisoners [append rand_arr n]  ;; Fill rand_arr with [1 2 3 ... 100]

;; --------------------------------------------------
;; strat_optimal: "optimal" strategy from the puzzle
;; Each prisoner starts at the locker with their own number,
;; then follows the chain inside the lockers until they find their number
;; or until they have opened 50 lockers.
;; Returns TRUE if the prisoner finds their own number, FALSE otherwise.
;; --------------------------------------------------
strat_optimal: func [pris /local locker][
    locker: pris                                    ;; Start at 'own-numbered' locker
    loop 50 [
        if Board/:locker = pris [ return true ]     ;; Found prisoner's number? -> success
        locker: Board/:locker                       ;; Move to the locker whose number was inside
    ]
    false                                           ;; Not found within 50 tries -> fail
]

;; --------------------------------------------------
;; strat_rand: "random" strategy
;; Each prisoner picks a random permutation of lockers,
;; then opens the first 50 in that random order, checking for their number.
;; Returns TRUE if found, FALSE if not.
;; --------------------------------------------------
strat_rand: func [pris][
    random rand_arr                                 ;; Randomize the locker opening order
    repeat n 50 [
        if Board/(rand_arr/:n) = pris [ return true ];; Check the nth randomly chosen locker
    ]                                                ;; If found -> success
    false                                            ;; Not found in 50 tries -> fail
]

;; --------------------------------------------------
;; check_board: Runs a strategy for the entire set of prisoners
;; Returns TRUE if *every prisoner* finds their number, FALSE if any fail.
;; Argument 'strat' is the symbol 'optimal or 'rand
;; --------------------------------------------------
check_board: func [strat][
    ;; Choose which strategy function to run
    strat: either strat = 'optimal [:strat_optimal] [:strat_rand]

    ;; Test each prisoner with the chosen strategy
    repeat pris prisoners [
        unless strat pris [return false]            ;; If any fail, run ends -> false
    ]
    true                                            ;; All prisoners succeeded -> true
]

saved: saved_rand: 0                                ;; Counters for the number of successful runs per strategy

;; --------------------------------------------------
;; Run the given number of simulations
;; --------------------------------------------------
loop K_runs [
    Board: random copy rand_arr                     ;; Create a random locker arrangement for this run
    if check_board 'optimal [saved: saved + 1]      ;; Attempt "optimal" strategy, count full successes
    if check_board 'rand    [saved_rand: saved_rand + 1]  ;; Attempt "random" strategy, count full successes
]

;; At this point:
;; - 'saved'       = number of runs where *all prisoners* survived using optimal strategy
;; - 'saved_rand'  = number of runs where *all prisoners* survived using random strategy
print ["runs" k_runs newline  "Percent saved opt.strategy:" saved * 100.0 / k_runs ]
print ["Percent saved random strategy:" saved_rand * 100.0 / k_runs ]
