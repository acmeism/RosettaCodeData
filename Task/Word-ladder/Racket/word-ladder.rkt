#lang racket

(define *unixdict* (delay (with-input-from-file "../../data/unixdict.txt"
                            (compose list->set port->lines))))

(define letters-as-strings (map string (string->list "abcdefghijklmnopqrstuvwxyz")))

(define ((replace-for-c-at-i w i) c)
  (string-append (substring w 0 i) c (substring w (add1 i))))

(define (candidates w)
  (for*/list (((i w_i) (in-parallel (string-length w) w))
              (r (in-value (replace-for-c-at-i w i)))
              (c letters-as-strings)
              #:unless (char=? w_i (string-ref c 0)))
    (r c)))

(define (generate-candidates word.path-hash)
  (for*/hash (((w p) word.path-hash)
              (w′ (candidates w)))
    (values w′ (cons w p))))

(define (hash-filter-keys keep-key? h)
  (for/hash (((k v) h) #:when (keep-key? k)) (values k v)))

(define (Word-ladder src dest (words (force *unixdict*)))
  (let loop ((edge (hash src null)) (unused (set-remove words src)))
    (let ((cands (generate-candidates edge)))
      (if (hash-has-key? cands dest)
          (reverse (cons dest (hash-ref cands dest)))
          (let ((new-edge (hash-filter-keys (curry set-member? unused) cands)))
            (if (hash-empty? new-edge)
                `(no-path-between ,src ,dest)
                (loop new-edge (set-subtract unused (list->set (hash-keys new-edge))))))))))

(module+ main
  (Word-ladder "boy" "man")
  (Word-ladder "girl" "lady")
  (Word-ladder "john" "jane")
  (Word-ladder "alien" "drool")
  (Word-ladder "child" "adult"))
