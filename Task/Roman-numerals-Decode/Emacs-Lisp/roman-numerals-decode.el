(defun ro2ar (RN)
  "Translate a roman number RN into arabic number.
   Its argument RN is wether a symbol, wether a list.
   Returns the arabic number. (ro2ar 'C) gives 100,
   (ro2ar '(X X I V)) gives 24"
  (cond
   ((eq RN 'M) 1000)
   ((eq RN 'D) 500)
   ((eq RN 'C) 100)
   ((eq RN 'L) 50)
   ((eq RN 'X) 10)
   ((eq RN 'V) 5)
   ((eq RN 'I) 1)
   ((null (cdr RN)) (ro2ar (car RN))) ;; stop recursion
   ((< (ro2ar (car RN)) (ro2ar (car (cdr RN)))) (- (ro2ar (cdr RN)) (ro2ar (car RN)))) ;; "IV" -> 5-1=4
   (t (+ (ro2ar (car RN)) (ro2ar (cdr RN)))))) ;; "VI" -> 5+1=6
