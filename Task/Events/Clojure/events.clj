(ns async-example.core
  (:require [clojure.core.async :refer [>! <! >!! <!! go chan]])
  (:require [clj-time.core :as time])
  (:require [clj-time.format :as time-format])
  (:gen-class))

;; Helper functions (logging & time stamp)
; Time stamp format
(def custom-formatter (time-format/formatter "yyyy:MM:dd:ss.SS"))

(defn safe-println [& more]
  " This function avoids interleaving of text output when using println due to race condition for multi-processes printing
    as discussed http://yellerapp.com/posts/2014-12-11-14-race-condition-in-clojure-println.html "
  (.write *out* (str (clojure.string/join " " more) "\n")))

(defn log [s]
  " Outputs mesage with time stamp "
  (safe-println (time-format/unparse custom-formatter (time/now)) ":" s))

;; Main code
(defn -main [& args]
  (let [c (chan)]
    (log "Program start")
    (go
      (log "Task start")
      (log (str "Event received by task: "(<! c))))

    (<!!
      (go
        (log "program sleeping")
        (Thread/sleep 1000)     ; Wait 1 second
        (log "Program signaling event")
        (>! c "reset")          ; Send message to task
          ))))

; Invoke -main function
(-main)
