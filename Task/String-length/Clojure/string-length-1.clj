(def utf-8-octet-length #(-> % (.getBytes "UTF-8") count))
(map utf-8-octet-length  ["møøse" "𝔘𝔫𝔦𝔠𝔬𝔡𝔢" "J\u0332o\u0332s\u0332e\u0301\u0332"]) ; (7 28 14)

(def utf-16-octet-length (comp (partial * 2) count))
(map utf-16-octet-length ["møøse" "𝔘𝔫𝔦𝔠𝔬𝔡𝔢" "J\u0332o\u0332s\u0332e\u0301\u0332"]) ; (10 28 18)

(def code-unit-length count)
(map code-unit-length    ["møøse" "𝔘𝔫𝔦𝔠𝔬𝔡𝔢" "J\u0332o\u0332s\u0332e\u0301\u0332"]) ; (5 14 9)
