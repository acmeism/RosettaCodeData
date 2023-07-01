(ns yprompt.core
  (:import jline.Terminal)
  (:gen-class))

(defn yes? [k]
  (if (or (= k 89) (= k 121)) true false))

(defn prompt []
    (println "\nPrompt again [Y/N]?")
    (let [term (Terminal/getTerminal)
          ykey (yes? (.readCharacter term System/in))]
      (if-not ykey
        (recur)
        (println "Yes!"))))

(defn -main [& args]
  (prompt))
