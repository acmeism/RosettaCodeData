(use srfi-13)
(use srfi-42)

(define (shatter separators the-string)
  (let loop ((str the-string) (tmp ""))
    (if (string=? "" str)
      (list tmp)
      (if-let1 sep (find (^s (string-prefix? s str)) separators)
        (cons* tmp sep
          (loop (string-drop str (string-length sep)) ""))
        (loop (string-drop str 1) (string-append tmp (string-take str 1)))))))

(define (glean shards)
  (list-ec (: x (index i) shards)
    (if (even? i)) x))
