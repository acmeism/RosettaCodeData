(import '[java.util GregorianCalendar])
(defn yuletide [start end]
  (->> (range start (inc end))
       (filter #(= GregorianCalendar/SUNDAY
                   (.get (GregorianCalendar. % GregorianCalendar/DECEMBER 25)
                         GregorianCalendar/DAY_OF_WEEK)))))

(println (yuletide 2008 2121))
