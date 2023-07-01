(ns rosetta-code.line-printer
  (:import java.io.FileWriter))

(defn -main [& args]
  (with-open [wr (new FileWriter "/dev/lp0")]
    (.write wr "Hello, World!")))
