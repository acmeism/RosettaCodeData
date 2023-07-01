(defn make-address
  ([city place-name] (str place-name ", " city))
  ([city street house-number] (str house-number " " street ", " city))
  ([city street house-number apartment] (str house-number " " street ", Apt. " apartment ", " city)))

;; To call the function you just need to pass whatever arguments you are supplying as you would with a fixed number

;; First case- the queen doesn't need a street name
(make-address "London" "Buckingham Palace"); => "Buckingham Palace, London"

;; Second case
(make-address "London" "Downing Street" 10); => "10 Downing Street, London"

;; Third case
(make-address "London" "Baker Street" 221 "B"); => "221 Baker Street, Apt. B, London"
