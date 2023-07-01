user> (sort #(compare (second %1) (second %2)) *langs*) ; using a comparator

(["Lisp" 1958] ["Scheme" 1975] ["Common Lisp" 1984] ["Haskell" 1990] ["Java" 1995] ["Clojure" 2007])

user> (sort-by second > *langs*) ; using a keyfn and a comparator

(["Clojure" 2007] ["Java" 1995] ["Haskell" 1990] ["Common Lisp" 1984] ["Scheme" 1975] ["Lisp" 1958])
