(defun merge-alists (alist1 alist2)
  (nconc
   (loop :for pair1 :in alist1
         :for pair2 := (assoc (car pair1) alist2)
         :do (setf alist2 (remove pair2 alist2))
         :collect (or pair2 pair1))
   alist2))

(defun merge-plists (plist1 plist2)
  (let ((res '()))
    (loop :for (key val) :on plist1 :by #'cddr
          :do (setf (getf res key) val))
    (loop :for (key val) :on plist2 :by #'cddr
          :do (setf (getf res key) val))
    res))
