(defn re-quote
  "Produces a string that can be used to create a Pattern
   that would match the string text as if it were a literal pattern.
   Metacharacters or escape sequences in text will be given no special
   meaning"
  [text]
  (java.util.regex.Pattern/quote text))

(defn count-substring [txt sub]
  (count (re-seq (re-pattern (re-quote sub)) txt)))
