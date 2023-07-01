(ns bubblesort
  (:import java.util.ArrayList))

(defn bubble-sort
  "Sort in-place.
  arr must implement the Java List interface and should support
  random access, e.g. an ArrayList."
  ([arr] (bubble-sort compare arr))
  ([cmp arr]
     (letfn [(swap! [i j]
                    (let [t (.get arr i)]
                      (doto arr
                        (.set i (.get arr j))
                        (.set j t))))
             (sorter [stop-i]
                     (let [changed (atom false)]
                       (doseq [i (range stop-i)]
                         (if (pos? (cmp (.get arr i) (.get arr (inc i))))
                           (do
                             (swap! i (inc i))
                             (reset! changed true))))
                       @changed))]
       (doseq [stop-i (range (dec (.size arr)) -1 -1)
               :while (sorter stop-i)])
       arr)))

(println (bubble-sort (ArrayList. [10 9 8 7 6 5 4 3 2 1])))
