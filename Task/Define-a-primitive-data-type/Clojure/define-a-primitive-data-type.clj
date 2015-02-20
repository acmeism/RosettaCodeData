(defn tinyint [^long value]
  (if (<= 1 value 10)
    (proxy [Number] []
      (doubleValue [] value)
      (longValue [] value))
    (throw (ArithmeticException. "integer overflow"))))
