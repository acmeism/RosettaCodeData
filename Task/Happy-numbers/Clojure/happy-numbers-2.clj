(require '[clojure.set :refer [union]])

(def ^{:private true} cache {:happy (atom #{}) :sad (atom #{})})

(defn break-apart [n]
  (->> (str n)
       (map str)
       (map #(Long/parseLong %))))

(defn next-number [n]
  (->> (break-apart n)
       (map #(* % %))
       (apply +)))

(defn happy-or-sad? [prev n]
  (cond (or (= n 1) ((deref (:happy cache)) n)) :happy
	(or ((deref (:sad cache)) n) (some #(= % n) prev)) :sad
	:else :unknown))

(defn happy-algo [n]
  (let [get-next (fn [[prev n]] [(conj prev n) (next-number n)])
	my-happy-or-sad? (fn [[prev n]] [(happy-or-sad? prev n) (conj prev n)])
	unknown? (fn [[res nums]] (= res :unknown))
	[res nums] (->> [#{} n]
			(iterate get-next)
			(map my-happy-or-sad?)
			(drop-while unknown?)
			first)
	_ (swap! (res cache) union nums)]
    res))

(def happy-numbers (->> (iterate inc 1)
                        (filter #(= :happy (happy-algo %)))))

(println (take 8 happy-numbers))
