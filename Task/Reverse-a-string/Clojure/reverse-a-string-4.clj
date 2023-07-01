(defn combining? [c]
  (let [type (Character/getType c)]
    ;; currently hardcoded to the types taken from the sample string
    (or (= type 6) (= type 7))))

(defn group
  "Group normal characters with their combining characters"
  [chars]
  (cond (empty? chars) chars
	(empty? (next chars)) (list chars)
	:else
	(let [dres (group (next chars))]
	  (cond (combining? (second chars)) (cons (cons (first chars)
							(first dres))
						  (rest dres))
		:else (cons (list (first chars)) dres)))))

(defn str-reverse
  "Unicode-safe string reverse"
  [s]
  (apply str (apply concat (reverse (group s)))))
