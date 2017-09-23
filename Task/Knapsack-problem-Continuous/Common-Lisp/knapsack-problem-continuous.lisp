(defstruct item
  (name nil :type string)
  (weight nil :type real)
  (price nil :type real))

(defun price-per-weight (item)
  (/ (item-price item) (item-weight item)))

(defun knapsack (items total-weight)
  (loop with sorted = (sort items #'> :key #'price-per-weight)
        while (plusp total-weight)
        for item in sorted
        for amount = (min (item-weight item) total-weight)
        collect (list (item-name item) amount)
        do (decf total-weight amount)))

(defun main ()
  (let ((items (list (make-item :name "beef"    :weight 3.8 :price 36)
                     (make-item :name "pork"    :weight 5.4 :price 43)
                     (make-item :name "ham"     :weight 3.6 :price 90)
                     (make-item :name "greaves" :weight 2.4 :price 45)
                     (make-item :name "flitch"  :weight 4.0 :price 30)
                     (make-item :name "brawn"   :weight 2.5 :price 56)
                     (make-item :name "welt"    :weight 3.7 :price 67)
                     (make-item :name "salami"  :weight 3.0 :price 95)
                     (make-item :name "sausage" :weight 5.9 :price 98))))
    (loop for (name amount) in (knapsack items 15)
          do (format t "~8A: ~,2F kg~%" name amount))))
