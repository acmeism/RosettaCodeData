(ns hello-seesaw.core
  (:use seesaw.core))

(defn -main [& args]
  (invoke-later
    (-> (frame
           :listen [:key-pressed (fn [e] (println (.getKeyChar e) " key pressed"))]
           :on-close :exit)
     pack!
     show!)))
