(defn str-fuzzy= [a b]
  (let [cook (fn [v] (clojure.string/trim (str v)))]
    (= (cook a) (cook b))))

(str-fuzzy= "abc" "  abc")     ; true
(str-fuzzy= "abc" "abc ")      ; true
(str-fuzzy= "abc" "  abc ")    ; true

(str-fuzzy= "   42 " 42)       ; true
(str-fuzzy= "   42 " (* 6 7))  ; true

(str-fuzzy= " 2.5" (/ 5.0 2))  ; true
