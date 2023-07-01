(defn apply-discount [discount-percentage price]
  "Function to apply a discount to a price"
  (-> price
      (* (- 100 discount-percentage)) ;; Apply discount
      (/ 100.0)))

;; Here we have assigned the variable to a partial function
;; It means 'call apply-discount with 10 as the first argument'
(def discount-10pc-option-1 (partial apply-discount 10))

;; And is equivalent to this:
(defn discount-10pc-option-2 [price]
  (apply-discount 10 price))

(discount-10pc-option-1 100); => 90

(discount-10pc-option-2 100); => 90
