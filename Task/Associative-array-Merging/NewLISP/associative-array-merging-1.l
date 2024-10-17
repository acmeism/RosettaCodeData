(setq data1 '("name" "Rocket Skates"
            "price" 12.75
            "color" "yellow"))

(setq data2 '("price" 	15.25
          "color" 	"red"
          "year" 	1974))

(define (list->alist lst)  (explode lst 2))

(macro (aset! Alist Key Val)
  (local (E-Message)
    (unless
      (catch
        (setf (assoc Key Alist) (list ($it 0) Val))
        'E-Message)
      (setf Alist (cons (list Key Val) Alist)))))

(define (foo list1 list2)
  (let (out (list->alist list1))
    (dolist (a (list->alist list2))
      (aset! out (a 0) (string (a 1))))
    (println out "\n")
    (dolist (a out)
      (println (format "%-5s  %s" a)))))

(foo data1 data2)
