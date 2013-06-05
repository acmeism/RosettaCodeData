;; Reads the maze from the textual form
;; read-maze :: File-path -> Maze
(define (read-maze file)
  (define tbl (make-hash))
  (with-input-from-file file
    (λ ()
      ; the first line gives us the width of the maze
      (define N (/ (- (string-length (read-line)) 1) 4))
      ; while reading other lines we get the height of the maze
      (define M
        (for/sum ([h (in-lines)] [v (in-lines)] [j (in-naturals)])
          (for ([i (in-range N)])
            (when (eq? #\space (string-ref h (* 4 (+ 1 i))))
              (connect! tbl (list i j) (list (+ i 1) j)))
            (when (eq? #\space (string-ref v (+ 1 (* 4 i))))
              (connect! tbl (list i j) (list i (+ j 1)))))
          1))
      (maze N M tbl))))
