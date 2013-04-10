(def *data* (atom {:a 100 :b 100})) ;; *data* is an atom holding a map
(swap! *data* xfer :a :b 50) ;; atomically results in *data* holding {:a 50 :b 150}
