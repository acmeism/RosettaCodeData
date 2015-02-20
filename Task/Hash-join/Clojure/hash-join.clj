(defn hash-join [table1 col1 table2 col2]
  (let [hashed (group-by col1 table1)]
    (flatten
      (for [r table2]
        (for [s (hashed (col2 r))]
          (merge s r))))))

(def s '({:age 27 :name "Jonah"}
         {:age 18 :name "Alan"}
         {:age 28 :name "Glory"}
         {:age 18 :name "Popeye"}
         {:age 28 :name "Alan"}))

(def r '({:nemesis "Whales" :name "Jonah"}
         {:nemesis "Spiders" :name "Jonah"}
         {:nemesis "Ghosts" :name "Alan"}
         {:nemesis "Zombies" :name "Alan"}
         {:nemesis "Buffy" :name "Glory"}))

(pprint (sort-by :name (hash-join s :name r :name)))
