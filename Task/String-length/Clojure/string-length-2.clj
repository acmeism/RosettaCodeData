(def character-length #(.codePointCount % 0 (count %)))
(map character-length    ["møøse" "𝔘𝔫𝔦𝔠𝔬𝔡𝔢" "J\u0332o\u0332s\u0332e\u0301\u0332"]) ; (5 7 9)
