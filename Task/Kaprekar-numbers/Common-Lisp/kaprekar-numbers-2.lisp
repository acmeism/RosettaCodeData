;; Generate Kaprekar Numbers using Casting Out Nines Generator
;;
;; Nigel Galloway - October 1st., 2012
;;
(defconstant Base 10)
(defconstant MAX 1000000)
(defconstant ran (let ((N ()) (Base-1 (- Base 1))) (do ((cnt Base-1 (- cnt 1))) ((zerop cnt) (return N))
   (if (= (mod (* cnt (- cnt 1)) Base-1) 0) (setf N (cons cnt N))))))

(defun kap () (let ((Paddy_cnt 0) (Base-1 (- Base 1))) (do ((n 0 (+ n Base-1))) ((> n MAX) ()) (dolist (G ran)
   (let ((N (+ G n))) (if (>= MAX N) (let ((kk (* N N))) (do ((B Base (* B Base))) (nil)
     (let (( nr (/ (* N (- B N)) (- B 1)))) (if (< 0 nr) (let ((q (floor (- N nr)))) (if (= kk (+ nr (* q B)))
       (format t "~3d: ~8d is ~8d + ~8d and squared is ~8d~&" (incf Paddy_cnt) N q nr kk))
     (if (> B kk) (return)))))))))))))
