(ns clojure-sandbox.prisoners)

(defn random-drawers []
  "Returns a list of shuffled numbers"
  (-> 100
      range
      shuffle))

(defn search-50-random-drawers [prisoner-number drawers]
  "Select 50 random drawers and return true if the prisoner's number was found"
  (->> drawers
      shuffle ;; Put drawer contents in random order
      (take 50) ;; Select first 50, equivalent to selecting 50 random drawers
      (filter (fn [x] (= x prisoner-number))) ;; Filter to include only those that match prisoner number
      count
      (= 1))) ;; Returns true if the number of matching numbers is 1

(defn search-50-optimal-drawers [prisoner-number drawers]
  "Open 50 drawers according to the agreed strategy, returning true if prisoner's number was found"
  (loop [next-drawer prisoner-number ;; The drawer index to start on is the prisoner's number
         drawers-opened 0] ;; To keep track of how many have been opened as 50 is the maximum
    (if (= drawers-opened 50)
      false ;; If 50 drawers have been opened, the prisoner's number has not been found
      (let [result (nth drawers next-drawer)] ;; Open the drawer given by next number
        (if (= result prisoner-number) ;; If prisoner number has been found
          true ;; No need to keep opening drawers - return true
          (recur result (inc drawers-opened))))))) ;; Restart the loop using the resulting number as the drawer number

(defn try-luck [drawers drawer-searching-function]
  "Returns 1 if all prisoners find their number otherwise 0"
  (loop [prisoners (range 100)] ;; Start with 100 prisoners
    (if (empty? prisoners) ;; If they've all gone and found their number
      1 ;; Return true- they'll all live
      (let [res (-> prisoners
                    first
                    (drawer-searching-function drawers))] ;; Otherwise, have the first prisoner open drawers according to the specified method
        (if (false? res) ;; If this prisoner didn't find their number
          0 ;; no prisoners will be freed so we can return false and stop
          (recur (rest prisoners))))))) ;; Otherwise they've found the number, so we remove them from the queue and repeat with the others

(defn simulate-100-prisoners []
  "Simulates all prisoners searching the same drawers by both strategies, returns map showing whether each was successful"
  (let [drawers (random-drawers)] ;; Create 100 drawers with randomly ordered prisoner numbers
    {:random (try-luck drawers search-50-random-drawers) ;; True if all prisoners found their number using random strategy
     :optimal (try-luck drawers search-50-optimal-drawers)})) ;; True if all prisoners found their number using optimal strategy

(defn simulate-n-runs [n]
  "Simulate n runs of the 100 prisoner problem and returns a success count for each search method"
  (loop [random-successes 0
         optimal-successes 0
         run-count 0]
    (if (= n run-count) ;; If we've done the loop n times
      {:random-successes random-successes ;; return results
       :optimal-successes optimal-successes
       :run-count run-count}
      (let [next-result (simulate-100-prisoners)] ;; Otherwise, run for another batch of prisoners
        (recur (+ random-successes (:random next-result)) ;; Add result of run to the total successs count
               (+ optimal-successes (:optimal next-result))
               (inc run-count)))))) ;; increment run count and run again

(defn -main [& args]
  "For 5000 runs, print out the success frequency for both search methods"
  (let [{:keys [random-successes optimal-successes run-count]} (simulate-n-runs 5000)]
    (println (str "Probability of survival with random search: " (float (/ random-successes run-count))))
    (println (str "Probability of survival with ordered search: " (float (/ optimal-successes run-count))))))
