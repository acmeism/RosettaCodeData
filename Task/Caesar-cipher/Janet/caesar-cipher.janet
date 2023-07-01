(def alphabet "abcdefghijklmnopqrstuvwxyz")

(defn rotate
  "shift bytes given x"
  [str x]
  (let [r (% x (length alphabet))
        b (string/bytes str)
        abyte (get (string/bytes "a") 0)
        zbyte (get (string/bytes "z") 0)]
    (var result @[])
    (for i 0 (length b)
      (let [ch (bor (get b i) 0x20)]  # convert uppercase to lowercase
        (when (and (<= abyte ch) (<= ch zbyte))
          (array/push result (get alphabet (% (+ (+ (+ (- zbyte abyte) 1) (- ch abyte)) r) (length alphabet)))))))
    (string/from-bytes ;result)))

(defn code
  "encodes and decodes str given argument type"
  [str rot type]
  (case type
    :encode (rotate str rot)
    :decode (rotate str (* rot -1))))

(defn main [& args]
  (let [cipher (code "The quick brown fox jumps over the lazy dog" 23 :encode)
        str (code cipher 23 :decode)]
    (print cipher)
    (print str)))
