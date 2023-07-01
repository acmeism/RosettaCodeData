(defn bind [val f]
  (if-let [v (:value val)] (f v) val))

(defn unit [val] {:value val})

(defn opt_add_3 [n] (unit (+ 3 n))) ; takes a number and returns a Maybe number
(defn opt_str [n] (unit (str n)))   ; takes a number and returns a Maybe string

(bind (unit 4) opt_add_3)                  ; evaluates to {:value 7}
(bind (unit nil) opt_add_3)                ; evaluates to {:value nil}
(bind (bind (unit 8) opt_add_3) opt_str)   ; evaluates to {:value "11"}
(bind (bind (unit nil) opt_add_3) opt_str) ; evaluates to {:value nil}
