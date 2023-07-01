(define (in-variants n1 o1 n2 o2 n3 o3 n4)
  (let ([o1n (object-name o1)]
        [o2n (object-name o2)]
        [o3n (object-name o3)])
    (with-handlers ((exn:fail:contract:divide-by-zero? (λ (_) empty-sequence)))
      (in-parallel
       (list  (o1 (o2 (o3 n1 n2) n3) n4)
              (o1 (o2 n1 (o3 n2 n3)) n4)
              (o1 (o2 n1 n2) (o3 n3 n4))
              (o1 n1 (o2 (o3 n2 n3) n4))
              (o1 n1 (o2 n2 (o3 n3 n4))))
       (list `(((,n1 ,o3n ,n2) ,o2n ,n3) ,o1n ,n4)
             `((,n1 ,o2n (,n2 ,o3n ,n3)) ,o1n ,n4)
             `((,n1 ,o2n ,n2) ,o1n (,n3 ,o3n ,n4))
             `(,n1 ,o1n ((,n2 ,o3n ,n3) ,o2n ,n4))
             `(,n1 ,o1n (,n2 ,o2n (,n3 ,o3n ,n4))))))))
