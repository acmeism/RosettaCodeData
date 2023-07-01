(use '(incanter core stats charts io))

(defn Arquimidean-function
  [a b theta]
  (+ a (* theta b)))

(defn transform-pl-xy [r theta]
  (let [x (* r (sin theta))
        y (* r (cos theta))]
    [x y]))

(defn arq-spiral [t] (transform-pl-xy (Arquimidean-function 0 7 t) t))

(view (parametric-plot arq-spiral 0 (* 10 Math/PI)))
