; generate our test string of characters with control and extended characters
(def range-of-chars (apply str (map char (range 256))))

; filter out the control characters:
(apply str (filter #(not (Character/isISOControl %)) range-of-chars))

; filter to return String of characters that are between 32 - 126:
(apply str (filter #(<= 32 (int %) 126) range-of-chars))
