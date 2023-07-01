(let
  [numbers '(first second third fourth fifth sixth
             seventh eighth ninth tenth eleventh twelfth)

   gifts   ["And a partridge in a pear tree",   "Two turtle doves",
            "Three French hens",                "Four calling birds",
            "Five gold rings",                  "Six geese a-laying",
            "Seven swans a-swimming",           "Eight maids a-milking",
            "Nine ladies dancing",              "Ten lords a-leaping",
            "Eleven pipers piping",             "Twelve drummers drumming"]

   day     (fn [n]
               (printf "On the %s day of Christmas, my true love sent to me\n"
                       (nth numbers n)))]

  (day 0)
  (println  (clojure.string/replace (first gifts) "And a" "A"))
  (dorun (for [d (range 1 12)] (do
    (println)
    (day d)
    (dorun (for [n (range d -1 -1)]
      (println (nth gifts n))))))))
