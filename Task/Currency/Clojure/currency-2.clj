(require '[io.randomseed.bankster.money :as m])

(let [burgers    (m/mul #money[USD 5.50] 4000000000000000)
      milkshakes (m/mul #money[USD 2.86] 2)
      pre-tax    (m/add burgers milkshakes)
      tax        (m/with-rounding UP (m/mul pre-tax 0.0765))]
  (println "Total before tax: " (m/format pre-tax))
  (println "             Tax: " (m/format tax))
  (println "  Total with tax: " (m/format (m/add pre-tax tax))))
