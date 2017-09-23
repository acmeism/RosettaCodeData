(ns example
  (:gen-class))

(defn abs [x]
  (if (> x 0)
    x
    (- x)))

(defn calc-benford-stats [digits]
  " Frequencies of digits in data "
  (let [y (frequencies digits)
         tot (reduce + (vals y))]
    [y tot]))

(defn show-benford-stats [v]
  " Prints in percent the actual, Benford expected, and difference"
  (let [fd (map (comp first str) v)]        ; first digit of each record
    (doseq [q (range 1 10)
            :let [[y tot] (calc-benford-stats fd)
                  d (first (str q))         ; reference digit
                  f (/ (get y d 0) tot 0.01)  ; percent of occurence of digit
                  p (* (Math/log10 (/ (inc q) q)) 100)  ; Benford expected percent
                  e (abs (- f p))]]                     ; error (difference)
      (println (format "%3d %10.2f %10.2f %10.2f"
                       q
                       f
                       p
                       e)))))

; Generate fibonacci results
(def fib (lazy-cat [0N 1N] (map + fib (rest fib))))

;(def fib-digits (map (comp first str) (take 10000 fib)))
(def fib-digits (take 10000 fib))
(def header "         found-%    expected-%  diff")

(println "Fibonacci Results")
(println header)
(show-benford-stats fib-digits)
;
; Universal Constants from Physics (using first column of data)
(println "Universal Constants from Physics")
(println header)
(let [
      data-parser (fn [s]
                  (let [x (re-find #"\s{10}-?[0|/\.]*([1-9])" s)]
                    (if (not (nil? x))    ; Skips records without number
                      (second x)
                      x)))

      input (slurp "http://physics.nist.gov/cuu/Constants/Table/allascii.txt")

      y (for [line (line-seq (java.io.BufferedReader.
                               (java.io.StringReader. input)))]
          (data-parser line))
      z (filter identity y)]
  (show-benford-stats z))

; Sunspots
(println "Sunspots average count per month since 1749")
(println header)
(let [
      data-parser (fn [s]
                  (nth (re-find #"(.+?\s){3}([1-9])" s) 2))

      ; Sunspot data loaded from file (saved from ;https://solarscience.msfc.nasa.gov/greenwch/SN_m_tot_V2.0.txt")
      ; (note: attempting to load directly from url causes https Trust issues, so saved to file after loading to Browser)
      input (slurp "SN_m_tot_V2.0.txt")
      y (for [line (line-seq (java.io.BufferedReader.
                               (java.io.StringReader. input)))]
          (data-parser line))]

  (show-benford-stats y))
