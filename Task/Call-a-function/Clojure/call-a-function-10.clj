;;You can assign it to a variable:

(def receipt-us (format-receipt "Toilet Paper" 5 format-price-us))

;; Then the variable holds the value
receipt-us; => "Toilet Paper $5"

;; Or you can use it in a call to another function

(defn add-store-name [receipt]
  "A function to add a footer to the receipt"
  (str receipt "\n Thanks for shopping at Safeway" ))

;; Calls add-store-name with the result of the format function
(add-store-name (format-receipt "Toilet Paper" 5 format-price-us)); => "Toilet Paper $5\n Thanks for shopping at Safeway"
