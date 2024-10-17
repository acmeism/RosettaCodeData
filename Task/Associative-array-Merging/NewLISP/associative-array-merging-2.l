(setq data1 '("name" "Rocket Skates"
            "price" 12.75
            "color" "yellow"))

(setq data2 '("price" 	3.20
          "color" 	"red"
          "year" 	1974))

(macro (ainc! Alist Key Val Func)
  (local (E-Message)
    (unless Func (set 'Func +))
    (unless
      (catch
        (setf (assoc Key Alist)
          (list ($it 0) (Func (or Val 1) ($it 1))))
        'E-Message)
      (setf Alist (cons (list Key (or Val 1)) Alist)))))

(define (list->alist xs)
  (collect
    (and (true? xs)
      (if (= "color" (xs 0))
        (list (pop xs) (list (pop xs)))
        (list (pop xs) (pop xs))))))

(define (bu) (bind (apply unify $args)))

(define (foo list1 list2   , K V)
  (let (out (list->alist list1))
    (dolist (a (list->alist list2))
      (bu '(K V) a)
      (case K
        ("price" (ainc! out K V add))
        ("color" (ainc! out K V append))
        ;; ainc! can even be used to make a new entry or replace old value.
        (true    (ainc! out K V or))))
    (println out "\n")
    (dolist (a out)
      (bu '(K V) a)
      (println (format "%-5s  " K) V))))

(foo data1 data2)
