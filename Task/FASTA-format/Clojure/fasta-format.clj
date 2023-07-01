(defn fasta [pathname]
  (with-open [r (clojure.java.io/reader pathname)]
    (doseq [line (line-seq r)]
      (if (= (first line) \>)
          (print (format "%n%s: " (subs line 1)))
        (print line)))))
