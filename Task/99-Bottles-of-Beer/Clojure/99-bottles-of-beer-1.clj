(defn sing
  [start]
  (doseq [n (range start 0 -1)]
    (printf "%d bottles of beer on the wall,
%d bottles of beer,
Take one down, pass it around,
%d bottles of beer on the wall.\n\n"
          n
          n
          (dec n))))

(sing 99)
