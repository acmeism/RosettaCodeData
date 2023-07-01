;; Print Zeckendorf numbers upto 20.
;; I have implemented this as a state machine.
;; Nigel Galloway - October 13th., 2012
;;
(let ((fibz '(13 8 5 3 2 1))) (dotimes (G 21) (progn (format t "~S is " G)
   (let ((z 0) (ng G)) (dolist (N fibz)
     (if (> z 1) (progn (setq z 1) (format t "~S" 0))
       (if (>= ng N) (progn (setq z 2) (setq ng (- ng N)) (format t "~S" 1))
         (if (= z 1) (format t "~S" 0)))))
   (if (= z 0) (format t "~S~%" 0) (format t "~%"))))))
