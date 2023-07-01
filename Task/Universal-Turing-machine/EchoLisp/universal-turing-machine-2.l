(define steps 0)
(define (TM-task T)
    (define count (TM-run T #f 1000000))
    (when (zero? steps) (writeln 'START (date)))
    (+= steps count)
    (writeln 'TM-steps steps (date))
    (when (zero? count) (writeln 'END steps (date)))
    (if (zero? count) #f T)) ;; return #f to signal end of task
