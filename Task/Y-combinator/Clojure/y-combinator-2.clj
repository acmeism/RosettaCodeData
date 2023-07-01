(defn Y [f]
  (#(% %) #(f (fn [& args] (apply (% %) args)))))
