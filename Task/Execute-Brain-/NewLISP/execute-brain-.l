; This module translates a string containing a
; Brainf*** program into a list of NewLISP expressions.
; Attempts to optimize consecutive +, -, > and < operations
; as well as bracket loops.

; Create a namespace and put the following definitions in it

(context 'BF)

; If BF:quiet is true, BF:run will return the output of the
; Brainf*** program

(define quiet)

; If BF:show-timing is true, the amount of milliseconds spent
; in 'compiling' (actually translating) and running the
; resulting program will be shown

(define show-timing true)

; The Brainf*** program as a string of characters

(define src "")

; Checks for correct pairs of brackets

(define (well-formed?)
  (let (p 0)
    (dostring (i src (> 0 p))
      (case i
	("[" (++ p))
	("]" (-- p))))
    (zero? p)))

; Translate the Brainf*** command into S-expressions

(define (_compile)
  (let ((prog '())
	; Translate +
	(incr '(++ (tape i) n))
	; Translate -
	(decr '(-- (tape i) n))
	; Translate .
        (emit (if quiet
		'(push (char (tape i)) result -1)
                '(print (char (tape i)))))
	; Translate ,
	(store '(setf (tape i) (read-key)))
	; Check for loop condition
	(over? '(zero? (tape i)))
	; Current character of the program
	(m)
	; Find how many times the same character occurs
	(rep (fn ((n 1))
		 (while (= m (src 0))
		 (++ n)
		 (pop src))
	     n)))
    ; Traverse the program and translate recursively
    (until (or (empty? src) (= "]" (setq m (pop src))))
	   (case m
	     (">" (push (list '++ 'i (rep)) prog -1))
	     ("<" (push (list '-- 'i (rep)) prog -1))
	     ("+" (push (expand incr '((n (rep))) true) prog -1))
	     ("-" (push (expand decr '((n (rep))) true) prog -1))
	     ("." (push emit prog -1))
	     ("," (push store prog -1))
	     ("[" (push (append (list 'until over?)
				(_compile))
			prog -1))))
    prog))

(define (compile str , tim code)
  (setq src (join
	(filter (fn (x)
		    (member x '("<" ">" "-" "+"
				"." "," {[} {]})))
		(explode str))))
  ; Throw an error if the program is ill-formed
  (unless (well-formed?)
    (throw-error "Unbalanced brackets in Brainf*** source string"))
  (setq tim (time (setq code (cons 'begin (_compile)))))
  (and show-timing (println "Compilation time: " tim))
  code)

; Translate and run
; Tape size is optional and defaults to 30000 cells

(define (run str (size 30000))
  (let ((tape (array size '(0)))
	 (i 0)
	 (result '())
	 (tim 0)
	 (prog (compile str)))
    (setq tim (time (eval prog)))
    (and show-timing (println "Execution time: " tim))
    (and quiet (join result))))

; test - run it with (BF:test)

(define (test)
  (run "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."))

; to interpret a string of Brainf*** code, use (BF:run <string>)
; to interpret a Brainf*** code file, use (BF:run (read-file <path-to-file>))
