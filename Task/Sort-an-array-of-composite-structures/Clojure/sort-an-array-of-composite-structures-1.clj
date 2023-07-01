;; Gathered with Google Squared
(def *langs* [["Clojure" 2007] ["Common Lisp" 1984] ["Java" 1995] ["Haskell" 1990]
              ["Lisp" 1958] ["Scheme" 1975]])

user> (sort-by second *langs*) ; using a keyfn

(["Lisp" 1958] ["Scheme" 1975] ["Common Lisp" 1984] ["Haskell" 1990] ["Java" 1995] ["Clojure" 2007])
