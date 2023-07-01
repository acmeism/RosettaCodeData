Remark- The native '''shuffle''' function implementation  in EchoLisp has been replaced by this one.
 Thx Rosetta Code.
(lib 'list) ;; for list-permute

;; use "inside-out" algorithm, no swapping needed.
;; returns a random permutation vector of [0 .. n-1]
(define (rpv n (j))
(define v (make-vector n))
	(for [(i n)]
		(set! j (random (1+ i)))
		(when (!= i j) (vector-set! v i [v j]))
		(vector-set! v j i))
	v)
	
;; apply to any kind of list
(define (k-shuffle list)
	(list-permute list (vector->list (rpv (length list)))))
	
;; out
(k-shuffle (iota 17))
    → (16 7 11 10 0 9 15 12 13 8 4 2 14 3 6 5 1)
	
(k-shuffle
'(adrien 🎸 alexandre 🚂  antoine  🍼 ben 📚   georges 📷   julie 🎥 marine 🐼 nathalie 🍕 ))
    → (marine alexandre 🎥 julie 🎸 ben 🍼 nathalie 📚 georges 🚂 antoine adrien 🐼 📷 🍕)

(shuffle ;; native
'(adrien 🎸 alexandre 🚂 antoine 🍼 ben 📚 georges 📷 julie 🎥 marine 🐼 nathalie 🍕 ))
    → (antoine 🎥 🚂 marine adrien nathalie 🍼 🍕 ben 🐼 julie 📷 📚 🎸 alexandre georges)
