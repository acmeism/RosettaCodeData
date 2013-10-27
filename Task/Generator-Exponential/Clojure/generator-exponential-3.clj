(defn seq->fn [sequence]
  (let [state (atom (cons nil sequence))]
    (fn [] (first (swap! state rest)))

(def f (seq->fn (squares-not-cubes)))
[(f) (f) (f)] ; => [4 9 16]
