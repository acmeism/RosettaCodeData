(def grapheme-length
  #(->> (doto (java.text.BreakIterator/getCharacterInstance)
          (.setText %))
        (partial (memfn next))
        repeatedly
        (take-while (partial not= java.text.BreakIterator/DONE))
        count))
(map grapheme-length     ["møøse" "𝔘𝔫𝔦𝔠𝔬𝔡𝔢" "J\u0332o\u0332s\u0332e\u0301\u0332"]) ; (5 7 4)
