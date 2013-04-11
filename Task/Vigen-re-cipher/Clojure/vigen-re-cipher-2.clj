(ns org.rosettacode.clojure.test-vigenere
  (:require [org.rosettacode.clojure.vigenere :as vigenere]))

(let
 [ plaintext  "Beware the Jabberwock, my son!  The jaws that bite, the claws that catch!"
   key        "Vigenere cipher"
   ciphertext (vigenere/encrypt plaintext  key)
   recovered  (vigenere/decrypt ciphertext key) ]

  (doall (map (fn [[k v]] (printf "%9s: %s\n" k v))
   [ ["Original" plaintext] ["Key" key] ["Encrypted" ciphertext] ["Decrypted" recovered] ])))
