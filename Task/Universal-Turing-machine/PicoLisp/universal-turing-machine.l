# Finite state machine
(de turing (Tape Init Halt Blank Rules Verbose)
   (let
      (Head 1
         State Init
         Rule NIL
         S 'start
         C (length Tape))
      (catch NIL
         (loop
            (state 'S
               (start 'print
                  (when (=0 C)
                     (setq Tape (insert Head Tape Blank))
                     (inc 'C) ) )
               (print 'lookup
                  (when Verbose
                     (for (N . I) Tape
                        (if (= N Head)
                           (print (list I))
                           (prin I) ) )
                     (prinl) )
                  (when (= State Halt) (throw NIL) ) )
               (lookup 'do
                  (setq Rule
                     (find
                        '((X)
                           (and
                              (= (car X) State)
                              (= (cadr X) (car (nth Tape Head))) ) )
                        Rules ) ) )
               (do 'step
                  (setq Tape (place Head Tape (caddr Rule))) )
               (step 'print
                  (cond
                     ((= (cadddr Rule) 'R) (inc 'Head))
                     ((= (cadddr Rule) 'L) (dec 'Head)) )
                  (cond
                     ((< Head 1)
                        (setq Tape (insert Head Tape Blank))
                        (inc 'C)
                        (one Head) )
                     ((> Head C)
                        (setq Tape (insert Head Tape Blank))
                        (inc 'C) ) )
                  (setq State (last Rule)) ) ) ) ) )
   Tape )

(println "Simple incrementer")
(turing '(1 1 1) 'A 'H 'B '((A 1 1 R A) (A B 1 S H)) T)

(println "Three-state busy beaver")
(turing '() 'A 'H 0
   '((A 0 1 R B)
     (A 1 1 L C)
     (B 0 1 L A)
     (B 1 1 R B)
     (C 0 1 L B)
     (C 1 1 S H)) T )

(println "Five-state busy beaver")
(let Tape (turing '() 'A 'H 0
   '((A 0 1 R B)
     (A 1 1 L C)
     (B 0 1 R C)
     (B 1 1 R B)
     (C 0 1 R D)
     (C 1 0 L E)
     (D 0 1 L A)
     (D 1 1 L D)
     (E 0 1 S H)
     (E 1 0 L A)) NIL)
   (println '0s: (cnt '((X) (= 0 X)) Tape))
   (println '1s: (cnt '((X) (= 1 X)) Tape)) )

(bye)
