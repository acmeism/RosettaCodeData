(def files (sort (filter #(= "." (.getParent %)) (file-seq (clojure.java.io/file ".")))))

(doseq [n files] (println (.getName n)))
