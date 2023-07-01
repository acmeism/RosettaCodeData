(ns rosetta.brute-force
  (:require [clojure.math.combinatorics :refer [selections]]) ;; https://github.com/clojure/math.combinatorics
  (:import  [java.util Arrays]
            [java.security MessageDigest]))

;;https://rosettacode.org/wiki/Parallel_Brute_Force

(def targets ;; length = 5
  ["1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad"
   "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"
   "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"])

;; HELPER/UTIL fns
;;=================

(defn digest
  "Given a byte-array <bs> returns its hash (also a byte-array)."
  ^bytes [^MessageDigest md ^bytes bs]
  (.digest md bs))

(defn char-range
  "Helper fn for easily producing character ranges."
  [start end]
  (map char (range (int start)
                   (inc (int end)))))

(def low-case-eng-bytes
  "Our search-space (all lower case english characters converted to bytes)."
  (map byte (char-range \a \z)))

(defn hex->bytes
  "Converts a hex string to a byte-array."
  ^bytes [^String hex]
  (let [len (.length hex)
        ret (byte-array (/ len 2))]
    (run! (fn [i]
            (aset ret
                  (/ i 2)
                  ^byte (unchecked-add-int
                          (bit-shift-left
                            (Character/digit (.charAt hex i) 16)
                            4)
                          (Character/digit (.charAt hex (inc i)) 16))))
          (range 0 len 2))
    ret))

(defn bytes->hex
  "Converts a byte-array to a hex string."
  [^bytes bs]
  (.toString
    ^StringBuilder
    (areduce bs idx ret (StringBuilder.)
      (doto ret (.append (format "%02x" (aget bs idx)))))))

;; MAIN LOGIC
;;===========

(defn check-candidate
  "Checks whether the SHA256 hash of <candidate> (a list of 5 bytes),
   matches <target>. If it does, returns that hash as a hex-encoded String.
   Otherwise returns nil."
  [^bytes target sha256 candidate]
  (let [candidate-bytes (byte-array candidate)
        ^bytes candidate-hash (sha256 candidate-bytes)]
    (when (Arrays/equals target candidate-hash)
      (let [answer (String. candidate-bytes)]
        (println "Answer found for:" (bytes->hex candidate-hash) "=>" answer)
        answer))))

(defn sha256-brute-force
  "Top level function. Returns a list with the 3 answers."
  [space hex-hashes]
  (->> hex-hashes
       (map hex->bytes) ;; convert the hex strings to bytes
       (pmap            ;; parallel map the checker-fn
         (fn [target-bytes]
           (let [message-digest (MessageDigest/getInstance "SHA-256") ;; new digest instance per thread
                 sha256 (partial digest message-digest)]
             (some (partial check-candidate target-bytes sha256)
                   (selections space 5)))))))
