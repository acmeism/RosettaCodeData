(define (foo  , INOUT Time mxcnt cnt line times tokens a)
  (let (handle (open "mlijobs.txt" "read"))
    (while (setq line (read-line handle))
      (setq tokens (parse line {[ ]+} 0))
      ;; Match the 7 tokens.
      (when (setq a (unify '(_ INOUT _ Time _ _ _) tokens))
        (bind a)  ;; Assign to variables INOUT and Time.
        (case INOUT
          ("OUT"
            (when (> (++ cnt) mxcnt) (setq mxcnt cnt) (setq times '()))
            (if (= cnt mxcnt) (push Time times)))
          ("IN" (-- cnt)))))
    (close handle)
    (list mxcnt times)))

(foo)

(99 ("2008/10/03_08:40:40" "2008/10/03_08:39:34"))
