(use '[clojure.string :only (join split)])
(def phrase "rosetta code phrase reversal")
(defn str-reverse [s] (apply str (reverse s)))

; Reverse string
(str-reverse phrase)
; Words reversed
(join " " (map str-reverse (split phrase #" ")))
; Word order reversed
(apply str (interpose " " (reverse (split phrase #" "))))
