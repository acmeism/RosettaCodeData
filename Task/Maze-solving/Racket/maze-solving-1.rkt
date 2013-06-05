;; Returns a path connecting two given cells in the maze
;; find-path :: Maze Cell Cell -> (Listof Cell)
(define (find-path m p1 p2)
  (match-define (maze N M tbl) m)
  (define (alternatives p prev) (remove prev (connections tbl p)))
  (define (dead-end? p prev) (empty? (alternatives p prev)))
  (define ((next-turn route) p)
    (define prev (car route))
    (cond
      [(equal? p p2) (cons p2 route)]
      [(dead-end? p prev) '()]
      [else (append-map (next-turn (cons p route))
                        (alternatives p prev))]))
  (reverse
   (append-map (next-turn (list p1))
               (alternatives p1 (list p1)))))
