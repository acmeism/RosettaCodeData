(defn str-before [a b]
  (neg? (compare a b)))

(defn str-after [a b]
  (pos? (compare a b)))

(str-before "abc" "def")   ; true
(str-before "def" "abc")   ; false
(str-before "abc" "abc")   ; false

(str-after "abc" "def")    ; false
(str-after "def" "abc")    ; false

(sort ["foo" "bar" "baz"])   ; ("bar" "baz" "foo")
