;; kill N-1
    (for ((i (1- N) )) (set! last-one (kill last-one  (1- K))))
;; look at prisoners
prisoners
→ ( 🔄 🔫 0 🔫 1 🔫 2 🔫 3 🔫 4 🔫 5 🔫 6 🔫 7 🔫 8 🔫 9 🔫 10 🔫 11 🔫 12 🔫 13 🔫 14 🔫 15 🔫 16
 🔫 17 🔫 18 🔫 19 🔫 20 🔫 21 🔫 22 🔫 23 🔫 24 🔫 25 🔫 26 🔫 27 🔫 28 🔫 29 😥 30 🔫 31 🔫 32
 🔫 33 🔫 34 🔫 35 🔫 36 🔫 37 🔫 38 🔫 39 🔫 40 🔫 0 🔫 1  … ∞)

;; #30 seems happy
;; kill last
(set! last-one (kill last-one (1- K)))
last-one
  → ( 🔫 30 🔫 31 🔫 32 …🔃 ) ;; #30 was the last

;; extra : we want more survivors
(define SURVIVORS 3)
(for ((i (- N SURVIVORS) )) (set! last-one (kill last-one  (1- K))))

prisoners
→  ( 🔄 🔫 0 🔫 1 🔫 2 🔫 3 🔫 4 🔫 5 🔫 6 🔫 7 🔫 8 🔫 9 🔫 10 🔫 11 🔫 12 🔫 13 🔫 14 😥 15 🔫 16
   🔫 17 🔫 18 🔫 19 🔫 20 🔫 21 🔫 22 🔫 23 🔫 24 🔫 25 🔫 26 🔫 27 🔫 28 🔫 29 😥 30 🔫 31 🔫 32
   🔫 33 😥 34 🔫 35 🔫 36 🔫 37 🔫 38 🔫 39 🔫 40 🔫 0 🔫 1  🔫 0 … ∞)

