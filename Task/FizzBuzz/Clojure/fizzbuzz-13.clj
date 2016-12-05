(take 100
  (
    (fn [& fbspec]
      (let [
             fbseq #(->> (repeat nil) (cons %2) (take %1) reverse cycle)
             strfn #(apply str (if (every? nil? (rest %&)) (first %&)) (rest %&))
          ]
        (->>
          fbspec
          (partition 2)
          (map #(apply fbseq %))
          (apply map strfn (rest (range)))
          ) ;;endthread
      ) ;;endlet
    ) ;;endfn
    3 "Fizz" 5 "Buzz" 7 "Bazz"
  ) ;;endfn apply
) ;;endtake
