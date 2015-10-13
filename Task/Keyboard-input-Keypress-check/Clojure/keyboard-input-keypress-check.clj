(ns keypress.core
  (:import jline.Terminal)
  (:gen-class))

(def keypress (future (.readCharacter (Terminal/getTerminal) System/in)))

(defn prompt []
  (println "Awaiting char...\n")
  (Thread/sleep 2000)
  (if-not (realized? keypress)
    (recur)
    (println "key: " (char @keypress))))

(defn -main [& args]
  (prompt)
  (shutdown-agents))
