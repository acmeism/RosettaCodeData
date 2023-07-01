(defn truncate [file size]
  (with-open [chan (.getChannel (java.io.FileOutputStream. file true))]
    (.truncate chan size)))

(truncate "truncate_test.txt" 2)
