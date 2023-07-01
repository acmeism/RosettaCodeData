(ns lychrel.core
  (require [clojure.string :as s])
  (require [clojure.set :as set-op])
  (:gen-class))

(defn palindrome? "Returns true if given number is a palindrome (number on base 10)"
  [number]
  (let [number-str (str number)]
    (= number-str (s/reverse number-str))))

(defn delete-leading-zeros
  "Delete leading zeros so that you can read the string"
  [number-str]
  (read-string (re-find (re-pattern "[1-9]\\d*") number-str))
  )

(defn lychrel "Returns T if number is a candidate Lychrel (up to max iterations), and a second value with the sequence of sums"
  ([number] (lychrel number 500))
  ([number depth]
   (let [next-number (+' number (delete-leading-zeros (s/reverse (str number))))
         depth (- depth 1)]
     (if (palindrome? next-number) (conj [next-number] number)
                                   (if (not= depth 0) (conj (lychrel next-number depth) number) (conj [] nil))
                                   )
     )))

(defn lychrel? "Test if number is a possible lychrel number"
  [number]
  (= nil (first (lychrel number 500))))

(defn lychrel-up-to-n "Get all lychrels up to N"
  [N]
  (filter lychrel? (range 1 N)))

(defn make-kin "Removes the starting number of the list, the starting number"
  [kin]
  (rest (butlast kin)))

(defn calc-seed "The seeding" []
  (let [kin-set (atom #{})
        seed-set (atom #{})]
    (fn [n] (let [lychrel-seed (set #{(last n)})
                  kins (set (butlast n))]
              (if (= kins (clojure.set/difference kins @kin-set))
                (do (swap! kin-set clojure.set/union kins)
                    (swap! seed-set clojure.set/union lychrel-seed)
                    @kin-set))
              @seed-set
              ))))

(defn filter-seeds "Filtering the seed through the paths"
  []
  (let [calc-f (calc-seed)
        all-lychrels (for [lychrel-list (filter lychrel? (range 1 10000))]
                       (filter (fn [x] (> 1000001 x)) (rest (lychrel lychrel-list))))]
    (last (for [ll all-lychrels]
            (do (calc-f ll))))))

(defn -main
  "Here we do the three tasks:
      Get all possible Lychrel numbers up to 10000
      Count them
      Reduce all possible numbers to seed"

  [& args]
  (let [lychrels-n (filter-seeds)
        count-lychrels (count lychrels-n)
        related-n (- (count (filter lychrel? (range 1 10000))) count-lychrels)
        palindrom-n (filter palindrome? (filter lychrel? (range 1 10000)))
        count-palindromes (count palindrom-n)
        ]
    (println count-lychrels "Lychrel seeds:"  lychrels-n)
    (println related-n "Lychrel related.")
    (println count-palindromes "Lychrel palindromes found:" palindrom-n))
  )
