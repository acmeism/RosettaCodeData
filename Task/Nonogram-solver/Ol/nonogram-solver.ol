(import (owl parse))

; notation parser
(define (subA x) (- x #\A -1))

(define line
   (let-parse* (
         (words (greedy+ (let-parse* (
               (* (greedy* (imm #\space)))
               (word (greedy+ (byte-if (lambda (x) (<= #\A x #\Z))))))
            (map subA word))))
         (* (maybe (imm #\newline) #f)))
      words))

(define nonogram-parser
   (let-parse* (
         (rows line)
         (cols line))
      (cons rows cols)))

; nonogram printer
(define (print-nonogram ng solve)
   (for-each (lambda (row y)
         (for-each (lambda (x)
               (if (list-ref (list-ref (car solve) y) x)
                  (display "X ")
                  (display ". ")))
            (iota (length (cdr ng))))
         (for-each (lambda (i)
               (display " ")
               (display i))
            row)
         (print))
      (car ng)
      (iota (length (car ng))))
   (for-each (lambda (i)
         (for-each (lambda (col)
               (let ((n (lref col i)))
                  (if n (display n) (display " ")))
               (display " "))
            (cdr ng))
         (print))
      (iota (fold (lambda (f col) (max f (length col))) 0 (cdr ng)) 0)))

; possible permutation generator
(define (permutate blacks len)
   ; empty cells distibutions (with minimal count)
   (define whites (append '(0) (repeat 1 (- (length blacks) 1)) '(0)))
   (define total (- len (apply + blacks))) ; total summ of empty cells

   (define (combine whites blacks)
      ; size of whites is always equal to size of blacks+1
      (let loop ((line #null) (v #f) (w (reverse whites)) (b (reverse blacks)))
         (if (null? w)
            line
         else
            (loop (append (repeat v (car w)) line)
                  (not v)
                  b
                  (cdr w)))))

   (map (lambda (whites) (combine whites blacks))
      (let loop ((ll whites) (max total))
         (if (null? (cdr ll))
            (list (list max))
         else
            (define sum (apply + ll))
            (define left (- max sum))
            (if (eq? left 0)
               (list ll)
               else
                  (define head (car ll))
                  (fold (lambda (f i)
                           (define sublist (loop (cdr ll) (- max head i)))
                           (fold (lambda (f x)
                                    (cons (cons (+ head i) x) f))
                              f
                              sublist))
                     #null
                     (iota (+ left 1))))))))

; siever of impossible combinations
(define (sieve rows cols) ; -> new cols
   (fold (lambda (cols i)
         ; for every cell define a "definitely black" and "definitely white" cells
         (define blacks (fold (lambda (f x)
               (map (lambda (a b) (and a b)) f x))
               (repeat #t (length cols))
               (list-ref rows i)))
         (define whites (fold (lambda (f x)
               (map (lambda (a b) (or a b)) f x))
               (repeat #f (length cols))
               (list-ref rows i)))
         ; now filter the second list
         (map (lambda (cols j)
               (filter (lambda (col)
                     (not (or
                        (and (list-ref blacks j) (not (list-ref col i)))
                        (and (not (list-ref whites j)) (list-ref col i)))))
                  cols))
            cols
            (iota (length cols))))
      cols
      (iota (length rows))))

; main solver cycle
(define (solve rows-permuted cols-permuted)
   (let loop ((rows rows-permuted) (cols cols-permuted) (flip #f))
      (define new-cols (sieve rows cols))

      (define fail (fold (lambda (f l) (or f (null? l))) #f new-cols))
      (define done (fold (lambda (f l) (and f (null? (cdr l)))) #t new-cols))

      (cond
         (fail
            #false)
         (done
            (if flip
               (cons (map car new-cols) (map car rows))
               (cons (map car rows) (map car new-cols))))
         (else
            (loop new-cols rows (not flip))))))

; -=( main )=----------------------------------
(define first "C BA CB BB F AE F A B
AB CA AE GA E C D C")

(define second "F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC
D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA")

(define third "CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC
BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF AAAAD BDG CEF CBDB BBB FC")

(define fourth "E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G
E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM")

(for-each (lambda (str)
      (print "nonogram:")
      (print str) (print)
      ; decode nonogram notation
      (define nonogram (parse nonogram-parser (str-iter str) #f #f #f))

      ; prepare arrays of all possible line b/w permutations
      (define rows (car nonogram))
      (define cols (cdr nonogram))

      (define row-length (length cols))
      (define col-length (length rows))

      (define rows-permuted (map (lambda (x) (permutate x row-length)) rows))
      (define cols-permuted (map (lambda (x) (permutate x col-length)) cols))

      ; solve nonogram
      (define answer (solve rows-permuted cols-permuted))

      ; show the output
      (if answer
         (print-nonogram nonogram answer)
         (print "Sorry, no aorrect answer found."))
      (print))
   (list first second third fourth))
