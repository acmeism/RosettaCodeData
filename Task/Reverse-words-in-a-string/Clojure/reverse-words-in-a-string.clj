(def poem
  "---------- Ice and Fire ------------

   fire, in end will world the say Some
   ice. in say Some
   desire of tasted I've what From
   fire. favor who those with hold I

   ... elided paragraph last ...

   Frost Robert -----------------------")

(dorun
  (map println (map #(apply str (interpose " " (reverse (re-seq #"[^\s]+" %)))) (clojure.string/split poem #"\n"))))
