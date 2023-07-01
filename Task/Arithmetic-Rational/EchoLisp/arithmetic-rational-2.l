;; rational operations
(+ 1/42 1/666) → 59/2331
42/666 → 7/111
(expt 3/4 7) → 2187/16384 ; 3/4 ^7
(/ 6 8) → 3/4   ;; / operator → rational
(// 6 8) → 0.75 ;; // operator → float
(* 6/7 14/12) → 1

;; even perfect numbers (up to 100000)
(for [(i (in-range 4 100000 2))] ;; 8 seconds
	(when (= (sum/inv i) 1)
		(printf "🍏 🍒 🍓 %d is perfect." i)))

🍏 🍒 🍓 6 is perfect.
🍏 🍒 🍓 28 is perfect.
🍏 🍒 🍓 496 is perfect.
🍏 🍒 🍓 8128 is perfect.
