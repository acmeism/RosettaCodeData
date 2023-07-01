(clojure.pprint/cl-format
  true
  "~{~[~^~]~:*~D bottle~:P of beer on the wall~%~:*~D bottle~:P of beer
Take one down, pass it around,~%~D bottle~:P~:* of beer on the wall.~2%~}"
  (range 99 0 -1))
