;; Here we have two functions to format a price depending on the country

(defn format-price-uk [price]
  (str "£" price))

(defn format-price-us [price]
  (str "$" price))

;; And one function that takes a price formatting function as an argument

(defn format-receipt [item-name price price-formatting-function]
  "Return the item name and price formatted according to the function"
  (str item-name
       " "
       (price-formatting-function price))) ;; Call the format function to get the right representation of the price

(format-receipt "Loo Roll" 5 format-price-uk); => "Loo Roll £5"

(format-receipt "Toilet Paper" 5 format-price-us); => "Toilet Paper $5"
