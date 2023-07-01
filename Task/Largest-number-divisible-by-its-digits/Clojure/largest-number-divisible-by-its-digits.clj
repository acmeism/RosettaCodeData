(require '[clojure.string :as str]) ;'
(def the_base 16)

;A sequence named digits containing the non-zero digits for the current number base.
(def digits (rest (range the_base)))

;A container for the digits which are prime.
(def primes [])

;Populate the primes sequence with the primes less than the current base.
(for [n digits] (if (= 1 (count (filter (fn[m] (and (< m n) (= 0 (mod n m)))) digits)) ) (def primes (conj primes n))))

;Determines the highest power of a given prime p that divides a given integer n.
(defn duplicity [n p partial] (if (= 0 (mod n p)) (duplicity (/ n p) p (conj partial p)) partial))

;Constructs the prime factorization of a given integer.
(defn factorize [n] (let [a (flatten (for [p (filter #(< % n) primes)]
  (remove #(= 1 %) (duplicity n p [1]))))] (if (= 0 (count a)) (lazy-seq [n]) a) ))

;Determines the number of times a given number appears in a given sequence of numbers.
(defn multiplicity [s n] (count (filter #(= n %) s)))

;Combines two sequence two create their "union" in the sense that in the resulting sequence
;each element from each sequence is uniquely represented and no smaller sequence would suffice.
;For example if one sequence contains two A's and other contains three A's, then the result will contain three A's.
;This is used to generate representations of prime factorizations and to construct least common multiples from them.
(defn combine [x y] (concat x (flatten (for [w (dedupe y)] (repeat (- (multiplicity y w) (multiplicity x w)) w) ))))

;deterimes the lcm least common multiple for a set of digits.
(defn lcm [s] (reduce * (reduce combine (map factorize s))))

;Retuns x^n.
(defn exp [x n] (reduce * (repeat n x)))

;Generates all non-empty subsequences for a sequence.
(defn non_empty_subsets [s] (for [x (reverse (rest (range (exp 2 (count s)))))]
  (remove nil? (for [i (range (count s))] (if (bit-test x i) (nth s i))))))


;Generates from a given sequence of digits in the current base the number that is s[0]s[1]s[2]...s[n].
;More generally, produces s[0]*the_base^n + s[1]*the_base^(n-1) + ... + s[n-1]*the_base^1 + s[n]*the_base^0
;for an arbitrary sequence of numbers.
(defn power_up [s] (reduce + (loop [idx (- (count s) 1) s_next s]
  (if (zero? idx) s_next (recur (dec idx) (map-indexed #(if (< %1 idx) (* %2 the_base) %2) s_next))))))

;Here is an alternative version of power_up that could be more efficient as it does not repeatedly recalculate powers of the base.
;Instead it calculates the dot product of s with a pre-populated sequence of powers of the base.
;Calculates the dot product of two vectors/sequences
;(defn dot [xs ys] (reduce + (map * xs ys)))
;(def places (map #(exp the_base %) (range the_base)))
;(defn power_up [s] (dot s (reverse (take (count s) places))))


;Returns the largest integer which contains each item from a given sequence exactly once as a digit.
(defn max_for_digits [s] (power_up (sort #(> %1 %2) s)))

;Returns the smallest non-negative integer which contains each item from a given sequence exactly once as a digit.
(defn min_for_digits [s] (power_up (sort #(< %1 %2) s)))

;calculate the logarithm of the input in the current base.
(defn log_base [x] (/ (Math/log x) (Math/log the_base)))

;Removes the zeros from a sequence
(defn remove_zeros [s] (remove #(= % 0) s))

;Returns the largest integer that is a multiple of a given integer and does not exceed another given integer.
(defn first_multiple_not_after [n ub] (loop [m ub] (if (= 0 (mod m n)) m (recur (dec m)))))

;creates a representation in the current base of a positive integer as a sequence listing the digits for the number in the base.
(defn representation [n] (let [full_power (int (log_base n))]
  (loop [power full_power place (exp the_base full_power) rep [] rem n ] (if (= power -1) rep
    (recur (dec power) (/ place the_base) (conj rep (int (/ rem place))) (- rem (* place (int (/ rem place)))))))))

;determines if a given number is exactly comprised of a given set of digits.
(defn digit_qualifies [m s] (let [rep_m (representation m)] (= (sort s) (sort rep_m))))

;Returns a sequence containing the largest Lynch-Bell number for the current base and a given sequence of digits
;or an empty sequence if there is none.
(defn find_s_largest_lb [s] (let [lb (min_for_digits s)] (let [m (lcm s)]
  (loop [v (first_multiple_not_after m (max_for_digits s))] (if (< v lb) []
    (if (digit_qualifies v s) (representation v) (recur (- v m))))))))

;Finds the largest Lynch-Bell number for the current base by looking for the largest for all subsets of a given size
;and picking the largest from those working from the largest size (most digits) to the smallest.
(defn find_largest_lb [] (let [subsets (non_empty_subsets (reverse digits))]
  (loop [s_size (- the_base 1)] (let [hits (remove #(= (count %) 0) (map find_s_largest_lb (filter #(= (count %) s_size) subsets)))]
    (if (pos? (count hits)) (first (sort #(first (remove_zeros (map - %2 %1))) hits)) (recur (dec s_size)))))))

;Converts small integers to hexidecimal digits.
;This isn't being used but could be leveraged to make output that looks normal for base 16.
(defn hex_digit [v] (case v 15 "F" 14 "E" 13 "D" 12 "C" 11 "B" 10 "A" (str v)))

(find_largest_lb)
