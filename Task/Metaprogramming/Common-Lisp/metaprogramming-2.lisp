[5]>
  (macroexpand'
     (loop for count from 1
           for x in '(1 2 3 4 5)
           summing x into sum
           summing (* x x) into sum-of-squares
           finally
             (return
               (let* ((mean (/ sum count))
                      (spl-var (- (* count sum-of-squares) (* sum sum)))
                      (spl-dev (sqrt (/ spl-var (1- count)))))
                 (values mean spl-var spl-dev)))))
(MACROLET ((LOOP-FINISH NIL (SYSTEM::LOOP-FINISH-ERROR)))
 (BLOCK NIL
  (LET ((COUNT 1))
   (LET ((#:LIST-3047 '(1 2 3 4 5)))
    (PROGN
     (LET ((X NIL))
      (LET ((SUM-OF-SQUARES 0) (SUM 0))
       (MACROLET ((LOOP-FINISH NIL '(GO SYSTEM::END-LOOP)))
        (TAGBODY SYSTEM::BEGIN-LOOP (WHEN (ENDP #:LIST-3047) (LOOP-FINISH))
         (SETQ X (CAR #:LIST-3047))
         (PROGN (SETQ SUM (+ SUM X))
          (SETQ SUM-OF-SQUARES (+ SUM-OF-SQUARES (* X X))))
         (PSETQ COUNT (+ COUNT 1)) (PSETQ #:LIST-3047 (CDR #:LIST-3047))
         (GO SYSTEM::BEGIN-LOOP) SYSTEM::END-LOOP
         (MACROLET
          ((LOOP-FINISH NIL (SYSTEM::LOOP-FINISH-WARN) '(GO SYSTEM::END-LOOP)))
          (PROGN
           (RETURN
            (LET*
             ((MEAN (/ SUM COUNT))
              (SPL-VAR (- (* COUNT SUM-OF-SQUARES) (* SUM SUM)))
              (SPL-DEV (SQRT (/ SPL-VAR (1- COUNT)))))
             (VALUES MEAN SPL-VAR SPL-DEV)))))))))))))) ; T
