(defn eval-with-x [program a b]
  (let [func (eval `(fn [~'x] ~program))]
    (- (func b) (func a))))
