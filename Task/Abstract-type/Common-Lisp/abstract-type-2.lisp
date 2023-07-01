(defmethod kar ((cons cons))
  (car cons))

(defmethod kdr ((cons cons))
  (cdr cons))

(konsp (cons 1 2))       ; => t
(typep (cons 1 2) 'kons) ; => t
(kar (cons 1 2))         ; => 1
(kdr (cons 1 2))         ; => 2
