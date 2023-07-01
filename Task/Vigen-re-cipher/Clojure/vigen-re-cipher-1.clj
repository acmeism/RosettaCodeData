(ns org.rosettacode.clojure.vigenere
  (:require [clojure.string :as string]))

; convert letter to offset from \A
(defn to-num [char] (- (int char) (int \A)))

; convert number to letter, treating it as modulo 26 offset from \A
(defn from-num [num] (char (+ (mod num 26) (int \A))))

; Convert a string to a sequence of just the letters as uppercase chars
(defn to-normalized-seq [str]
  (map #'first (re-seq #"[A-Z]" (string/upper-case str))))

; add (op=+) or subtract (op=-) the numerical value of the key letter from the
; text letter.
(defn crypt1 [op text key]
  (from-num (apply op (list (to-num text) (to-num key)))))

(defn crypt [op text key]
  (let [xcrypt1 (partial #'crypt1 op)]
    (apply #'str
      (map xcrypt1 (to-normalized-seq text)
                   (cycle (to-normalized-seq key))))))

; encipher a text
(defn encrypt [plaintext key] (crypt #'+ plaintext key))

; decipher a text
(defn decrypt [ciphertext key] (crypt #'- ciphertext key))
