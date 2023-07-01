(require '[clojure.edn :as edn])
(def names { 0 "zero"      1 "one"        2 "two"           3 "three"     4 "four"   5 "five"
             6 "six"       7 "seven"      8 "eight"         9 "nine"     10 "ten"   11 "eleven"
            12 "twelve"   13 "thirteen"  14 "fourteen"     15 "fifteen"
            16 "sixteen"  17 "seventeen" 18 "eighteen"     19 "nineteen"
            20 "twenty"   30 "thirty"    40 "forty"        50 "fifty"    60 "sixty"
            70 "seventy"  80 "eighty"    90 "ninety"      100 "hundred"

            1000          "thousand"     1000000          "million"      1000000000 "billion"
            1000000000000 "trillion"     1000000000000000 "quadrillion"
            1000000000000000000          "quintillion" })

(def powers-of-10 (reverse (sort (filter #(clojure.string/ends-with? (str %) "00") (keys names)))))

(defn name-of [n]
  (let [p (first (filter #(>= n %) powers-of-10))]
    (cond
      (not (nil? p))
        (let [quotient  (quot n p)
              remainder (rem  n p)]
              (str (name-of quotient) " " (names p) (if (> remainder 0) (str " " (name-of remainder)))))

      (and (nil? p) (> n 20))
        (let [remainder  (rem n 10)
              tens       (- n remainder)]
              (str (names tens) (if (> remainder 0) (str " " (name-of remainder)))))

      true
        (names n))))

(defn four-is-magic
  ([n] (four-is-magic n ""))
  ([n prefix]
   (let [name ((if (empty? prefix) clojure.string/capitalize identity) (name-of n))
         new-prefix (str prefix (if (not (empty? prefix)) ", "))]
   (if (= n 4)
    (str new-prefix name " is magic.")
    (let [len (count name)]
      (four-is-magic len (str new-prefix name " is " (name-of len))))))))

(defn report [n]
  (println (str n ": " (four-is-magic n))))

(defn -main [& args]
  (doall (map (comp report edn/read-string) args)))


(if (not= "repl" *command-line-args*)
  (apply -main *command-line-args*))
