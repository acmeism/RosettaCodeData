(defgeneric nsrt (sequence predicate))

(defmethod nsrt ((sequence sequence) predicate)
  (loop :for i :from 1 :below (length sequence)
        :do (loop :for j :from i :downto 1
                  :do (let ((current (elt sequence j))
                            (previous (elt sequence (1- j))))
                        (when (funcall predicate current previous)
                          (rotatef (elt sequence j)
                                   (elt sequence (1- j))))))
        :finally (return sequence)))

;; (nsrt "adfcghjiklmnoprbtuvqewysxz" #'char<)
;; => "abcdefghijklmnopqrstuvwxyz"
;;
;; (nsrt '(who the hecc do you think i am?)
;;       (lambda (x y)
;;         (string< (nsrt (format nil "~a" x) #'char<)
;;                  (nsrt (format nil "~a" y) #'char<))))
;; => (AM? HECC DO THE THINK WHO I YOU)
;;
;; (nsrt (loop :for i :from 1 :to 1000 :collect (random i))
;;       #'<)
;; => [not printed but works, try it!]
