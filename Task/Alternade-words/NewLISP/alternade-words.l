(let (handle (open "words" "read"))
  (setq word-list (collect (read-line handle)))
  (close handle))

(define (in-dict? word) (find word word-list))

(define (alternates word  , pair)
  (and
    (> (length word) 6)
    (setq pair
      (map (fn(s) (apply string (map first (explode s 2))))
           (list word (1 word))))
    (for-all in-dict? pair)
    pair))

(dolist (w word-list)
  (if (alternates w) (println w " " $it)))
