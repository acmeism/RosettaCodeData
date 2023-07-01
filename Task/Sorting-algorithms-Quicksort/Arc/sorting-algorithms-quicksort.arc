(def qs (seq)
  (if (empty seq) nil
      (let pivot (car seq)
	(join (qs (keep [< _ pivot] (cdr seq)))
	      (list pivot)
	      (qs (keep [>= _ pivot] (cdr seq)))))))
