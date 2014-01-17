(defn van-der-corput
  "Get the nth element of the van der Corput sequence."
  ([n]
   ;; Default base = 2
   (van-der-corput n 2))
  ([n base]
   (let [s (/ 1 base)]  ;; A multiplicand to shift to the right of the decimal.
     ;; We essentially want to reverse the digits of n and put them after the
     ;; decimal point. So, we repeatedly pull off the lowest digit of n, scale
     ;; it to the right of the decimal point, and accumulate that.
     (loop [sum 0
            n n
            scale s]
       (if (zero? n)
         sum  ;; Base case: no digits left, so we're done.
         (recur (+ sum (* (rem n base) scale))  ;; Accumulate the least digit
                (quot n base)                   ;; Drop a digit of n
                (* scale s)))))))               ;; Move farther past the decimal

(clojure.pprint/print-table
  (cons :base (range 10))  ;; column headings
  (for [base (range 2 6)]  ;; rows
    (into {:base base}
          (for [n (range 10)]  ;; table entries
            [n (van-der-corput n base)]))))
