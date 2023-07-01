(require '[clojurewerkz.money.amounts    :as ma])
(require '[clojurewerkz.money.currencies :as mc])
(require '[clojurewerkz.money.format     :as mf])

(let [burgers (ma/multiply (ma/amount-of mc/USD 5.50) 4000000000000000)
      milkshakes (ma/multiply (ma/amount-of mc/USD 2.86) 2)
      pre-tax (ma/plus burgers milkshakes)
      tax (ma/multiply pre-tax 0.0765 :up)]
  (println "Total before tax: " (mf/format pre-tax))
  (println "             Tax: " (mf/format tax))
  (println "  Total with tax: " (mf/format (ma/plus pre-tax tax))))
