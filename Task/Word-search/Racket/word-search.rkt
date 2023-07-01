#lang racket
;; ---------------------------------------------------------------------------------------------------
(module+ main
  (display-puzzle (create-word-search))
  (newline)
  (parameterize ((current-min-words 50))
    (display-puzzle (create-word-search #:n-rows 20 #:n-cols 20))))

;; ---------------------------------------------------------------------------------------------------
(define current-min-words (make-parameter 25))

;; ---------------------------------------------------------------------------------------------------
(define (all-words pzl)
  (filter-map (good-word? pzl) (file->lines "data/unixdict.txt")))

(define (good-word? pzl)
  (let ((m (puzzle-max-word-size pzl)))
    (λ (w) (and (<= 3 (string-length w) m) (regexp-match #px"^[A-Za-z]*$" w) (string-downcase w)))))

(struct puzzle (n-rows n-cols cells solutions) #:transparent)

(define puzzle-max-word-size (match-lambda [(puzzle n-rows n-cols _ _) (max n-rows n-cols)]))

(define dirs '((-1 -1 ↖) (-1 0 ↑) (-1 1 ↗) (0 -1 ←) (0 1 →) (1 -1 ↙) (1 0 ↓) (1 1 ↘)))

;; ---------------------------------------------------------------------------------------------------
(define (display-puzzle pzl) (displayln (puzzle->string pzl)))

(define (puzzle->string pzl)
  (match-let*
      (((and pzl (puzzle n-rows n-cols cells (and solutions (app length size)))) pzl)
       (column-numbers (cons "" (range n-cols)))
       (render-row (λ (r) (cons r (map (λ (c) (hash-ref cells (cons r c) #\_)) (range n-cols)))))
       (the-grid (add-between (map (curry map (curry ~a #:width 3))
                                   (cons column-numbers (map render-row (range n-rows)))) "\n"))
       (solutions§ (solutions->string (sort solutions string<? #:key car))))
    (string-join (flatten (list the-grid "\n\n" solutions§)) "")))

(define (solutions->string solutions)
  (let* ((l1 (compose string-length car))
         (format-solution-to-max-word-size (format-solution (l1 (argmax l1 solutions)))))
    (let recur ((solutions solutions) (need-newline? #f) (acc null))
      (if (null? solutions)
          (reverse (if need-newline? (cons "\n" acc) acc))
          (let* ((spacer (if need-newline? "\n" "   "))
                 (solution (format "~a~a" (format-solution-to-max-word-size (car solutions)) spacer)))
            (recur (cdr solutions) (not need-newline?) (cons solution acc)))))))

(define (format-solution max-word-size)
  (match-lambda [(list word row col dir)
                 (string-append (~a word #:width (+ max-word-size 1))
                                (~a (format "(~a,~a ~a)" row col dir) #:width 9))]))

;; ---------------------------------------------------------------------------------------------------
(define (create-word-search #:msg (msg "Rosetta Code") #:n-rows (n-rows 10) #:n-cols (n-cols 10))
  (let* ((pzl (puzzle n-rows n-cols (hash) null))
         (MSG (sanitise-message msg))
         (n-holes (- (* n-rows n-cols) (string-length MSG))))
    (place-message (place-words pzl (shuffle (all-words pzl)) (current-min-words) n-holes) MSG)))

(define (sanitise-message msg) (regexp-replace* #rx"[^A-Z]" (string-upcase msg) ""))

(define (place-words pzl words needed-words holes)
  (let inner ((pzl pzl) (words words) (needed-words needed-words) (holes holes))
    (cond [(and (not (positive? needed-words)) (zero? holes)) pzl]
          [(null? words)
           (eprintf "no solution... retrying (~a words remaining)~%" needed-words)
           (inner pzl (shuffle words) needed-words)]
          [else
           (let/ec no-fit
             (let*-values
                 (([word words...] (values (car words) (cdr words)))
                  ([solution cells′ holes′]
                   (fit-word word pzl holes (λ () (no-fit (inner pzl words... needed-words holes)))))
                  ([solutions′] (cons solution (puzzle-solutions pzl)))
                  ([pzl′] (struct-copy puzzle pzl (solutions solutions′) (cells cells′))))
               (inner pzl′ words... (sub1 needed-words) holes′)))])))

(define (fit-word word pzl holes fail)
  (match-let* (((puzzle n-rows n-cols cells _) pzl)
               (rows (shuffle (range n-rows)))
               (cols (shuffle (range n-cols)))
               (fits? (let ((l (string-length word))) (λ (maxz z0 dz) (< -1 (+ z0 (* dz l)) maxz)))))
    (let/ec return
      (for* ((dr-dc-↗ (shuffle dirs))
             (r0 rows) (dr (in-value (car dr-dc-↗))) #:when (fits? n-rows r0 dr)
             (c0 cols) (dc (in-value (cadr dr-dc-↗))) #:when (fits? n-cols c0 dc)
             (↗ (in-value (caddr dr-dc-↗))))
        (let/ec retry/ec (attempt-word-fit pzl word r0 c0 dr dc ↗ holes return retry/ec)))
      (fail))))

(define (attempt-word-fit pzl word r0 c0 dr dc ↗ holes return retry)
  (let-values (([cells′ available-cells′]
                (for/fold ((cells′ (puzzle-cells pzl)) (holes′ holes))
                          ((w word) (i (in-naturals)))
                  (define k (cons (+ r0 (* dr i)) (+ c0 (* dc i))))
                  (cond [(not (hash-has-key? cells′ k))
                         (if (zero? holes′) (retry) (values (hash-set cells′ k w) (sub1 holes′)))]
                        [(char=? (hash-ref cells′ k) w) (values cells′ holes′)]
                        [else (retry)]))))
    (return (list word r0 c0 ↗) cells′ available-cells′)))

;; ---------------------------------------------------------------------------------------------------
(define (place-message pzl MSG)
  (match-define (puzzle n-rows n-cols cells _) pzl)
  (struct-copy puzzle pzl
               (cells
                (let loop ((r 0) (c 0) (cells cells) (msg (string->list MSG)))
                  (cond [(or (null? msg) (= r n-rows)) cells]
                        [(= c n-cols) (loop (add1 r) 0 cells msg)]
                        [(hash-has-key? cells (cons r c)) (loop r (add1 c) cells msg)]
                        [else (loop r (add1 c) (hash-set cells (cons r c) (car msg)) (cdr msg))])))))
