;; Continuing on the same example, let's imagine Anna has a 20% discount card and Bill has 50%. Charlie pays full price
;; We can store their discount functions in a map

(def discount-cards {"Anna" discount-20pc
                     "Bill" discount-50pc
                     "Charlie" identity}) ;; Identity returns whatever value was passed to the function (in this case it will be price)

;; Now we can access them by cardholder name in another function
(defn calculate-discounted-price [price shopper-name]
  "Applies the correct discount for the person"
  (let [discount-fn (get discount-cards shopper-name)] ;; Get the right discount function
    (discount-fn price))) ;; Apply discount function to the price

(calculate-discounted-price 100 "Anna"); => 80
(calculate-discounted-price 100 "Bill"); => 50
(calculate-discounted-price 100 "Charlie"); => 100
