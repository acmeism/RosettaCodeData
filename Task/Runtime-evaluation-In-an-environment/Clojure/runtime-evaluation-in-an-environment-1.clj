(def ^:dynamic x nil)

(defn eval-with-x [program a b]
  (- (binding [x b] (eval program))
     (binding [x a] (eval program))))
