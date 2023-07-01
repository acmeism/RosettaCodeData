(define (find-solutions numbers (goal 24))
  (define in-operations (list + - * /))
  (remove-duplicates
   (for*/list ([n1 numbers]
               [n2 (remove-from numbers n1)]
               [n3 (remove-from numbers n1 n2)]
               [n4 (remove-from numbers n1 n2 n3)]
               [o1 in-operations]
               [o2 in-operations]
               [o3 in-operations]
               [(res expr) (in-variants n1 o1 n2 o2 n3 o3 n4)]
               #:when (= res goal))
     expr)))

(define (remove-from numbers . n) (foldr remq numbers n))
