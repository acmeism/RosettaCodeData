(require 'struct)

(struct TM (read-only: name states symbs final rules mem  state-values: tape pos state))

(define-syntax-rule (rule-idx state symb numstates)
    (+ state (* symb numstates)))

(define-syntax-rule (make-TM name states symbs rules)
    (_make-TM  name 'states 'symbs 'rules))

;; a rule is (state symbol --> write move new-state)
;; index for rule = state-num + (number of states)  * symbol-num
;; convert states/symbol into vector indices
(define (compile-rule T rule  into: rules)
    (define numstates (vector-length (TM-states T)))
    (define state (vector-index [rule 0](TM-states T) )) ; index
    (define symb (vector-index [rule 1](TM-symbs T) ))
    (define write-symb (vector-index [rule 2] (TM-symbs T)  ))
    (define move (1- (vector-index  [rule 3] #(left stay right) )))
    (define new-state (vector-index  [rule 4](TM-states T)))
    (define rulenum (rule-idx state symb numstates))
    (vector-set! rules rulenum (vector write-symb move new-state))
    ; (writeln 'rule  rulenum [rules rulenum])
    )

(define (_make-TM name states symbs rules)
    (define T (TM  name (list->vector states) (list->vector symbs) null null))
    (set-TM-final! T (1-  (length states))) ;; assume one final state
    (set-TM-rules! T (make-vector (* (length states) (length symbs))))
    (for ((rule rules)) (compile-rule T (list->vector rule) into: (TM-rules T)))
    T ) ; returns a TM

;;------------------
;; TM-trace
;;-------------------
(string-delimiter "")

(define (TM-print T symb-index: symb (hilite #f))
	(cond
	((= 0 symb) (if hilite "🔲"  "◽️" ))
	((= 1 symb) (if hilite  "🔳 " "◾️" ))
	(else "X")))
		
(define (TM-trace T tape pos state step)
	(if (= (TM-final T) state)
		(write "🔴")
		(write "🔵"))
		
    (for [(p (in-range  (- (TM-mem T) 7) (+ (TM-mem T) 8)))]
        (write (TM-print T [tape p] (= p pos))))
    (write step)
    (writeln))

;;---------------
;; TM-init : alloc and init tape
;;---------------
(define (TM-init T input-symbs (mem 20))
    ;; init state variables
    (set-TM-tape! T (make-vector (* 2 mem)))
    (set-TM-pos!  T  mem)
    (set-TM-state! T 0)
    (set-TM-mem! T mem)

    (for [(symb input-symbs) (i (in-naturals))]
        (vector-set! (TM-tape T) [+ i (TM-pos T)] (vector-index symb (TM-symbs T))))
    (TM-trace T  (TM-tape T) mem 0 0)
    mem )

;;---------------
;; TM-run : run at most maxsteps
;;---------------
(define (TM-run T  (verbose #f)  (maxsteps 1_000_000))
(define count 0)
    (define final (TM-final T))
    (define rules (TM-rules T))
    (define rule 0)
    (define numstates (vector-length (TM-states T)))
    ;; set current state vars
    (define pos (TM-pos T))
    (define state (TM-state T))
    (define tape (TM-tape T))

    (when (and (zero? state) (= pos (TM-mem T)))
    	 (writeln 'Starting (TM-name T))
    	 (TM-trace T tape pos 0 count))

    (while (and (!= state final) (< count maxsteps))
    (++ count)
;; The machine
        (set! rule [rules (rule-idx state [tape pos] numstates)])
        (when (= rule 0) (error "missing rule" (list state [tape pos])))
        (vector-set! tape pos [rule 0])
        (set! state [rule 2])
        (+= pos [rule 1])
;; end machine
        (when verbose (TM-trace  T tape pos state count )))
;; save TM state
    (set-TM-pos! T pos)
    (set-TM-state! T state)
    (when (= final state)  (writeln 'Stopping (TM-name T) 'at-pos (- pos (TM-mem T))))
    count)
