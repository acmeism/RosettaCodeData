(math/seedrandom (os/cryptorand 8))

(defn drawers
  "create list and shuffle it"
  [prisoners]
  (var x (seq [i :range [0 prisoners]] i))
  (loop [i :down [(- prisoners 1) 0]]
    (var j (math/floor (* (math/random) (+ i 1))))
    (var k (get x i))
    (put x i (get x j))
    (put x j k))
  x)

(defn optimal-play
  "optimal decision path"
  [prisoners drawers]
  (var result 0)
  (loop [i :range [0 prisoners]]
    (var choice i)
    (loop [j :range [0 50] :until (= (get drawers choice) i)]
      (set choice (get drawers choice)))
    (cond
      (= (get drawers choice) i) (++ result)
      (break)))
  result)

(defn random-play
  "random decision path"
  [prisoners d]
  (var result 0)
  (var options (drawers prisoners))
  (loop [i :range [0 prisoners]]
    (var choice 0)
    (loop [j :range [0 (/ prisoners 2)] :until (= (get d j) (get options i))]
      (set choice j))
    (cond
      (= (get d choice) (get options i)) (++ result)
      (break)))
  result)

(defn main [& args]
  (def prisoners 100)
  (var optimal-success 0)
  (var random-success 0)
  (var sims 10000)
  (for i 0 sims
    (var d (drawers prisoners))
    (if (= (optimal-play prisoners d) prisoners)
      (++ optimal-success))
    (if (= (random-play prisoners d) prisoners)
      (++ random-success)))
  (printf "Simulation count:  %d" sims)
  (printf "Optimal play wins: %.1f%%" (* (/ optimal-success sims) 100))
  (printf "Random play wins:  %.1f%%" (* (/ random-success sims) 100)))
