(require 'list)

;; a card is a vector  [id color number symb shading], 0 <= id < 81
(define (make-deck (id -1))
(for*/vector(
	[ color '(red green purple)]
	[ number '(one two three)]
	[ symb '( oval squiggle diamond)]
	[ shading '(solid open striped)]) (++ id) (vector id color number symb shading)))
(define DECK (make-deck))

;; pre-generate  531441 ordered triples, among which 6561 are winners
(define TRIPLES (make-vector (* 81 81 81)))
(define (make-triples )
   (for* ((i 81)(j 81)(k 81))
	(vector-set! TRIPLES (+ i (* 81 j) (* 6561 k))
		(check-set [DECK i] [DECK j] [DECK k]))))
	
;; a deal is a list of cards id's.
(define (show-deal deal)
   (for ((card deal)) (writeln [DECK card]))
   (for ((set (combinations deal 3)))
     (when
     (check-set [DECK (first set)] [DECK (second set)][DECK (third set)])
     (writeln 'winner set))))
		
;; rules of game here
(define (check-set cards: a b c)
	(for ((i (in-range 1 5))) ;; each feature
	#:continue (and (= [a i] [b i]) (= [a i] [c i]))
	#:continue (and (!= [a i] [b i]) (!= [a i] [c i]) (!= [b i][c i]))
	#:break  #t =>  #f ))
	
;; sets = list of triples (card-id card-id card-id)
(define (count-sets sets )
	(for/sum ((s sets))
    (if [TRIPLES ( + (first s) (* 81 (second s)) (* 6561 (third s)))]
    1 0)))
				

;; task
(make-triples)

(define (play (n 9) (cmax 4) (sets) (deal))
	(while #t
		(set! deal (take (shuffle (iota 81)) n))
		(set! sets (combinations deal 3))
		#:break (= (count-sets sets) cmax) => (show-deal deal)
		))
