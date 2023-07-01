(system::expand-form
    '(loop for count from 1
           for x in '(1 2 3 4 5)
           summing x into sum
           summing (* x x) into sum-of-squares
           finally
             (return
               (let* ((mean (/ sum count))
                      (spl-var (- (* count sum-of-squares) (* sum sum)))
                      (spl-dev (sqrt (/ spl-var (1- count)))))
                 (values mean spl-var spl-dev))))))
(BLOCK NIL
 (LET ((COUNT 1))
  (LET ((#:LIST-3230 '(1 2 3 4 5)))
   (LET ((X NIL))
    (LET ((SUM-OF-SQUARES 0) (SUM 0))
     (TAGBODY SYSTEM::BEGIN-LOOP
      (WHEN (ENDP #:LIST-3230) (GO SYSTEM::END-LOOP))
      (SETQ X (CAR #:LIST-3230))
      (PROGN (SETQ SUM (+ SUM X))
       (SETQ SUM-OF-SQUARES (+ SUM-OF-SQUARES (* X X))))
      (PSETQ COUNT (+ COUNT 1)) (PSETQ #:LIST-3230 (CDR #:LIST-3230))
      (GO SYSTEM::BEGIN-LOOP) SYSTEM::END-LOOP
      (RETURN-FROM NIL
       (LET*
        ((MEAN (/ SUM COUNT))
         (SPL-VAR (- (* COUNT SUM-OF-SQUARES) (* SUM SUM)))
         (SPL-DEV (SQRT (/ SPL-VAR (1- COUNT)))))
        (VALUES MEAN SPL-VAR SPL-DEV)))))))))
