(defun random-choice (items)
  (nth (random (length items)) items))

(random-choice '("a" "b" "c"))
;; => "a"
