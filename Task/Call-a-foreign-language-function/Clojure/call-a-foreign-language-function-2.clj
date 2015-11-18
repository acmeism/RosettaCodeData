(require '[net.n01se.clojure-jna :as jna])

(jna/invoke Integer c/strcmp "apple" "banana" )      ; returns -1

(jna/invoke Integer c/strcmp "banana" "apple" )      ; returns 1

(jna/invoke Integer c/strcmp "banana" "banana" )     ; returns 0
