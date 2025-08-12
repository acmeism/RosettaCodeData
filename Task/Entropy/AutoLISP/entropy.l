(defun entropy (str / log2 eCalc strList len ent cnt n new end cPrev)
  (defun log2 (x)
    (if (> x 0)
      (/ (log x) (log 2.0))
    )
  )
  (defun eCalc (cnt len / p)
    (setq p (/ (float cnt) len))
    (* p (log2 p))
  )
  (setq
    strList (acad_strlsort (mapcar 'chr (vl-string->list str)))
    len (length strList)
    ent 0.0
    cnt 0
    n 0
  )
  (foreach c strList
    (setq
      n (1+ n)
      new (and cPrev (not (eq c cPrev)))
      end (= n len)
    )
    (if (or new end)
      (setq
        cnt (if (and end (not new)) (1+ cnt) cnt)
        ent (+ ent (eCalc cnt len))
        cnt 0
      )
    )
    (if (and new end)
      (setq ent (+ ent (eCalc 1 len)))
    )
    (setq
      cnt (1+ cnt)
      cPrev c
    )
  )
  (* -1 ent)
)
