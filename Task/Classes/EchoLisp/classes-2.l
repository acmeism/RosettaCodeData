;; instantiate
(define simone     (make-instance Person  :name  'simone :age 42)) ;; slots values by name
(define antoinette (make-instance Person :name 'antoinette :age 37))
(define albert     (Person "albert" 33)) ;; quick way : slots values in order
(define simon (make-instance Writer :name "simon"   :books '(my-life my-bike)))


(mailto simone simon) ;; method Person-Writer
(mailto simone antoinette) ;; method Person-Person
(mailto simon albert) ;; no method Writer-Person : call 'super' Person-Person
(mailto simon simon) ;; no mehod Writer-Writer : call 'super' Person-Writer
   →
   From 🚶 simone (age 42). Dear writer of (my-life my-bike) ...
   From 🚶 simone to️ 🚶 antoinette : ...
   From 🎩 simon to️ 🚶 albert : ...
   From 🎩 simon (age 66). Dear writer of (my-life my-bike) ...
