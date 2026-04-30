(defun best-rate (l1 l2)
  "predicate for sorting a list of elements regarding the value/weight rate"
  (let*
      ((r1 (/ (* 1.0 (nth 2 l1)) (nth 1 l1)))
       (r2 (/ (* 1.0 (nth 2 l2)) (nth 1 l2))))
    (cond
     ((> r1 r2) t)
     (t nil))))

(defun ks1 (l max)
  "return a complete list - complete means 'less than max-weight
but add the next element is impossible'"
(let ((l (sort l 'best-rate)))
  (cond
   ((null l) l)
   ((<= (nth 1 (car l)) max)
    (cons (car l) (ks1 (cdr l) (- max (nth 1 (car l))))))
   (t (ks1 (cdr l) max)))))

(defun totval (lol)
  "totalize values of a list - lol is not for laughing
but for list of list"
  (cond
   ((null lol) 0)
   (t
    (+
     (nth 2 (car lol))
     (totval (cdr lol))))))

(defun ks (l max)
  "browse the list to find the best subset to put in the f***ing knapsack"
    (cond
     ((null (cdr l)) (list (car l)))
     (t
      (let*
          ((x (ks1 l max))
           (y (ks (cdr l) max)))
        (cond
         ((> (totval x) (totval y)) x)
         (t y))))))

        (ks '((map 9 150) (compass 13 35) (water 153 200) (sandwich 50 160)
              (glucose 15 60) (tin 68 45)(banana 27 60) (apple 39 40)
              (cheese 23 30) (beer 52 10) (cream 11 70) (camera 32 30)
              (T-shirt 24 15) (trousers 48 10) (umbrella 73 40)
              (waterproof-trousers 42 70) (overclothes 43 75) (notecase 22 80)
              (glasses 7 20) (towel 18 12) (socks 4 50) (book 30 10)) 400)
