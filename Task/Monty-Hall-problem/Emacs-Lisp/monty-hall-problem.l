(defun montyhall (keep)
  (let
      ((prize (random 3))
       (choice (random 3)))
    (if keep (= prize choice)
      (/= prize choice))))


(let ((cnt 0))
  (dotimes (i 10000)
    (and (montyhall t) (setq cnt (1+ cnt))))
  (princ (format "Strategy keep: %.3f %%" (/ cnt 100.0))))

(let ((cnt 0))
  (dotimes (i 10000)
    (and (montyhall nil) (setq cnt (1+ cnt))))
  (princ (format "Strategy switch: %.3f %%" (/ cnt 100.0))))
