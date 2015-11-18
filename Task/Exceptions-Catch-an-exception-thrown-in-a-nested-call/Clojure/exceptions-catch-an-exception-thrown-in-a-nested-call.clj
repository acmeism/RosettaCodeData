(def U0 (ex-info "U0" {}))
(def U1 (ex-info "U1" {}))

(defn baz [x] (if (= x 0) (throw U0) (throw U1)))
(defn bar [x] (baz x))

(defn foo []
  (dotimes [x 2]
    (try
      (bar x)
      (catch clojure.lang.ExceptionInfo e
        (if (= e U0)
          (println "foo caught U0")
          (throw e))))))

(defn -main [& args]
  (foo))
