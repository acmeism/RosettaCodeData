(define friends '( albert ludwig elvis 🌀))

(for-each write friends)→  albert ludwig elvis 🌀

; for loop
(for ((friend friends)) (write friend)) → albert ludwig elvis 🌀

; map a function
(map string-upcase friends)  → ("ALBERT" "LUDWIG" "ELVIS" "🌀")
(map string-randcase friends) → ("ALBerT" "LudWIG" "elVis" "🌀")

; recursive way
(define (rscan L)
    (unless (null? L)
        (write (first L))
         (rscan (rest L))))

(rscan friends)  →  albert ludwig elvis 🌀

; folding a list
; check that ∑ 1..n = n (n+1)/2

(define L (iota 1001))
(foldl + 0 L) → 500500 ; 1000 * 1001 / 2

