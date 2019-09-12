(defun random-choice (items)
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(random-choice '("a" "b" "c"))
;; => "a"
