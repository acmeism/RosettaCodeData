#lang racket
;; [LISTOF X] -> ( -> X u 'you-fell-off-the-end-off-the-list)
(define (generate-one-element-at-a-time a-list)
  ;; (-> X u 'you-fell-off-the-end-off-the-list)
  ;; this is the actual generator, producing one item from a-list at a time
  (define (generator)
     (call/cc control-state))
  ;; [CONTINUATION X] -> EMPTY
  ;; hand the next item from a-list to "return" (or an end-of-list marker)'
  (define (control-state return)
     (for-each
        (lambda (an-element-from-a-list)
           (set! return ;; fixed
             (call/cc
               (lambda (resume-here)
                 (set! control-state resume-here)
                 (return an-element-from-a-list)))))
        a-list)
     (return 'you-fell-off-the-end-off-the-list))
  ;; time to return the generator
  generator)
