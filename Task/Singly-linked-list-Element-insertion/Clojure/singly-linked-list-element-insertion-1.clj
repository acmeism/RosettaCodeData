(defn insert-after [new old ls]
  (cond (empty? ls) ls
        (= (first ls) old) (cons old (cons new (rest ls)))
        :else (cons (first ls) (insert-after new old (rest ls)))))
