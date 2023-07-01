(defn total-cost-with-discount [item-price num-items & [discount-percentage]]
  "Returns total price to buy the items after discount is applied (if given)"
  (let [discount (or discount-percentage 0)] ;; Assign discount to either the discount-percentage (if given) or default 0 if not
    (-> item-price
        (* num-items) ;; Calculate total cost
        (* (- 100 discount)) ;; Apply discount
        (/ 100.0))))

;; Now we can use the function without the optional arguments, and see the same behaviour as our total-cost function
(total-cost-with-discount 1 5); => 5

;; Or we can add the third parameter to calculate the cost with 20% discount
(total-cost-with-discount 1 5 20); => 4
