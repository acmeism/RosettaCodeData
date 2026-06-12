#lang racket
(require xml)

(define (char->bacon-number C)
  (define c (char-downcase C))
  (define c-code (- (char->integer c) (char->integer #\a)))
  (and (<= 0 c-code 26) (- c-code (if (> c-code  8) 1 0) (if (> c-code 20) 1 0))))

(define (inr-encode bacons f-cs seg/r rv/r last-bacon-bit fce)
  (cond
    [(null? bacons) (append (reverse (if (null? seg/r) rv/r (cons seg/r rv/r))) (list f-cs))]
    [(null? f-cs) (error 'bacon-encode->list "not enough false message to hide the text")]
    [(zero? last-bacon-bit) (inr-encode (cdr bacons) f-cs seg/r rv/r 5 fce)]
    [(not (char-alphabetic? (car f-cs)))
     (inr-encode bacons (cdr f-cs) (cons (car f-cs) seg/r) rv/r last-bacon-bit fce)]
    [else
     (define bit (sub1 last-bacon-bit))
     (define bs? (bitwise-bit-set? (car bacons) bit))
     (match-define (cons f-a f-d) f-cs)
     (match (cons bs? fce)
       [(or '(#f . 1) '(#t . 2)) (inr-encode bacons f-d (cons f-a seg/r) rv/r bit fce)]
       [_ (inr-encode bacons f-d (list f-a) (cons (reverse seg/r) rv/r) bit (if bs? 2 1))])]))

(define (bacon-encode->segments-list plain-text false-message)
  (define bacon-numbers (filter-map char->bacon-number (string->list plain-text)))
  (map list->string (inr-encode bacon-numbers (string->list false-message) null null 5 1)))

(define (bacon-encode->html plain-text false-message
                            (->face1 (λ (s) `(span ((face "1")) ,s)))
                            (->face2 (λ (s) `(span ((face "2")) ,s))))
  (define segments (bacon-encode->segments-list plain-text false-message))
  (xexpr->string
   (list* 'div '((style "white-space: pre"))
          (for/list ((seg (in-list segments)) (face (in-cycle (in-list (list ->face1 ->face2)))))
            (face seg)))))

(module+ main
  (define plain-text "i wrote this F.B.")
  (define false-text #<<EOS
To be, or not to be, that is the question:
Whether 'tis Nobler in the mind to suffer
The Slings and Arrows of outrageous Fortune,
[...]
EOS
    )

  (displayln (bacon-encode->html plain-text false-text values (λ (s) `(i ,s)))))
