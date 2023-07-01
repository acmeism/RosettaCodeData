;; They are the same thing - indeed, everything in clojure is a function
;; Functions without return values simply return nil

(defn no-return-value [a]
  (print (str "Your argument was" a "; now returning nil")))

(no-return-value "hi"); => nil
