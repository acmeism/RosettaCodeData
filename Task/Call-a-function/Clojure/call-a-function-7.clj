(defn make-discount-function [discount-percent]
  "Returns a function that takes a price and applies the given discount"
  (fn [price] (-> price
                  (* (- 100 discount-percent))
                  (/ 100.0))))

;; Now we can create a '20% off' function to calculate prices with your discount card
(def discount-20pc (make-discount-function 20))

;; Use the function to calculate some discount prices
(discount-20pc 100); => 80
(discount-20pc 5); => 4

;; Your friend has a better discount card, we can use the same function to create their discount card function
(def discount-50pc (make-discount-function 50))
(discount-50pc 100); => 50
(discount-50pc 5); => 2.5
