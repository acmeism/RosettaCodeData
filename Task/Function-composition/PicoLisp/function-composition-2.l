(def 'a (compose inc dec))
(def 'b (compose 'inc 'dec))
(def 'c (compose '((A) (inc A)) '((B) (dec B))))
