#lang racket
(struct node (edges ; edges (or forward links)
              link ; suffix link (backward links)
              len) ; the length of the node
  #:mutable)

(define (new-node link len) (node (make-hash) link len))

(struct eertree (nodes
                 rto ; odd length root node, or node -1
                 rte ; even length root node, or node 0
                 S ; accumulated input string, T=S[1..i]
                 max-suf-t) ; maximum suffix of tree T
  #:mutable)

(define (new-eertree)
  (let* ((rto (new-node #f -1))
         (rte (new-node rto 0)))
    (eertree null rto rte (list 0) rte)))

(define (eertree-get-max-suffix-pal et start-node a)
  #| We traverse the suffix-palindromes of T in the order of decreasing length.
     For each palindrome we read its length k and compare T[i-k] against a
     until we get an equality or arrive at the -1 node. |#
  (match et
    [(eertree nodes rto rte (and S (app length i)) max-suf-t)
     (let loop ((u start-node))
       (let ((k (node-len u)))
         (if (or (eq? u rto) (= (list-ref S (- i k 1)) a))
             u
             (let ((u→ (node-link u)))
               (when (eq? u u→) (error 'eertree-get-max-suffix-pal "infinite loop"))
               (loop u→)))))]))

(define (eertree-add! et a)
  #| We need to find the maximum suffix-palindrome P of Ta
     Start by finding maximum suffix-palindrome Q of T.
     To do this, we traverse the suffix-palindromes of T
     in the order of decreasing length, starting with maxSuf(T) |#
  (match (eertree-get-max-suffix-pal et (eertree-max-suf-t et) a)
    [(node Q.edges Q.→ Q.len)
     ;; We check Q to see whether it has an outgoing edge labeled by a.
     (define new-node? (not (hash-has-key? Q.edges a)))
     (when new-node?
       (define P (new-node #f (+ Q.len 2))) ; We create the node P of length Q+2
       (set-eertree-nodes! et (append (eertree-nodes et) (list P)))
       (define P→
         (if (= (node-len P) 1)
             (eertree-rte et) ; if P = a, create the suffix link (P,0)
             ;; It remains to c reate the suffix link from P if |P|>1.
             ;; Just continue traversing suffix-palindromes of T starting with the suffix link of Q.
             (hash-ref (node-edges (eertree-get-max-suffix-pal et Q.→ a)) a)))
       (set-node-link! P P→)
       (hash-set! Q.edges a P)) ; create the edge (Q,P)

     (set-eertree-max-suf-t! et (hash-ref Q.edges a)) ; P becomes the new maxSufT
     (set-eertree-S! et (append (eertree-S et) (list a))) ; Store accumulated input string
     new-node?]))

(define (eertree-get-sub-palindromes et)
  (define (inr nd (node-path (list nd)) (char-path/rev null))
    ;; Each node represents a palindrome, which can be reconstructed by the path from the root node to
    ;; each non-root node.
    (let ((deeper ; Traverse all edges, since they represent other palindromes
           (for/fold ((result null)) (([→-name nd2] (in-hash (node-edges nd))))
             ; The lnk-name is the character used for this edge
             (append result (inr nd2 (append node-path (list nd2)) (cons →-name char-path/rev)))))
          (root-node? (or (eq? (eertree-rto et) nd) (eq? (eertree-rte et) nd))))
      (if root-node? ; Don't add root nodes
          deeper
          (let ((even-string? (eq? (car node-path) (eertree-rte et)))
                (char-path (reverse char-path/rev)))
            (cons (append char-path/rev (if even-string? char-path (cdr char-path))) deeper)))))
  inr)

(define (eertree-get-palindromes et)
  (define sub (eertree-get-sub-palindromes et))
  (append (sub (eertree-rto et))
          (sub (eertree-rte et))))

(module+ main
  (define et (new-eertree))
  ;; eertree works in integer space, so we'll map to/from char space here
  (for ((c "eertree")) (eertree-add! et (char->integer c)))
  (map (compose list->string (curry map integer->char)) (eertree-get-palindromes et)))
