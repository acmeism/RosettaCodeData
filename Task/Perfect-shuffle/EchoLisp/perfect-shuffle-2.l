map magic-shuffle '(8 24 52 100 1020 1024 10000))
    → ((8 . 3) (24 . 11) (52 . 8) (100 . 30) (1020 . 1018) (1024 . 10) (10000 . 300))

;; Let's look in the On-line Encyclopedia of Integer Sequences
;; Given a list of numbers, the (oeis ...) function looks for a sequence

(lib 'web)
Lib: web.lib loaded.
map magic-shuffle (range 2 18 2))
    → ((2 . 1) (4 . 2) (6 . 4) (8 . 3) (10 . 6) (12 . 10) (14 . 12) (16 . 4))
(oeis '(1 2 4 3 6 10 12 4))
→ Sequence A002326 found
