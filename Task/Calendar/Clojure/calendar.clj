(require '[clojure.string :only [join] :refer [join]])

(def day-row "Su Mo Tu We Th Fr Sa")

(def col-width (count day-row))

(defn month-to-word
  "Translate a month from 0 to 11 into its word representation."
  [month]
  ((vec (.getMonths (new java.text.DateFormatSymbols))) month))

(defn month [date]
  (.get date (java.util.Calendar/MONTH)))

(defn total-days-in-month [date]
  (.getActualMaximum date (java.util.Calendar/DAY_OF_MONTH)))

(defn first-weekday [date]
  (.get date (java.util.Calendar/DAY_OF_WEEK)))

(defn normal-date-string
  "Returns a formatted list of strings of the days of the month."
  [date]		
  (map #(join " " %)
    (partition 7
      (concat
        (repeat (dec (first-weekday date)) "  ")
        (map #(format "%2s" %)
               (range 1 (inc (total-days-in-month date))))
        (repeat (- 42 (total-days-in-month date)
                      (dec (first-weekday date)) ) "  ")))))

		
(defn oct-1582-string
  "Returns a formatted list of strings of the days of the month of October 1582."
  [date]
  (map #(join " " %)
    (partition 7
      (concat
         (repeat (dec (first-weekday date)) "  ")
         (map #(format "%2s" %)
                 (concat (range 1 5)
                         (range 15 (inc (total-days-in-month date)))))
         (repeat (- 42
                    (count (concat (range 1 5)
		                   (range 15
                                          (inc (total-days-in-month date)))))
                    (dec (first-weekday date)) ) "  ")))))


(defn center-string
  "Returns a string that is WIDTH long with STRING centered in it."
  [string width]
  (let [pad (- width (count string))
        lpad (quot pad 2)
        rpad (- pad (quot pad 2))]
    (if (<= pad 0)
    string
    (str (apply str (repeat lpad " "))  ; remove vector
          string
         (apply str (repeat rpad " "))))))


(defn calc-columns
  "Calculates the number of columns given the width in CHARACTERS and the
   MARGIN SIZE."
  [characters margin-size]
  (loop [cols 0 excess  characters ]
    (if (>= excess  col-width)
        (recur (inc cols) (- excess (+ margin-size col-width)))
         cols)))

(defn month-vector
  "Returns a vector with the month name, day-row and days
   formatted for printing."
  [date]
  (vec (concat
         (vector (center-string (month-to-word (month date)) col-width))
         (vector day-row)
 		 (if (and (= 1582 (.get date (java.util.Calendar/YEAR)))
		 		  (= 9 (month date)))
		     (oct-1582-string date)
                     (normal-date-string date)))))

(defn year-vector [date]
  "Returns a 2d vector of all the months in the year of DATE."
  (loop [m [] c (month date)]
    (if (= c 11 )
        (conj m (month-vector date))
        (recur (conj m (month-vector date))
               (do (.add date (java.util.Calendar/MONTH ) 1)
                   (month date))))))

(defn print-months
  "Prints the months to standard output with NCOLS and MARGIN."
  [ v ncols margin]
  (doseq [r (range (Math/ceil (/ 12 ncols)))]
    (do (doseq [i (range 8)]
          (do (doseq [c (range (* r ncols) (* (+ r 1) ncols))
		                :while (< c 12)]
              (printf (str (apply str (repeat margin " ")) "%s")
		      (get-in v [c i])))
          (println)))
        (println))))

(defn print-cal
  "(print-cal [year [width [margin]]])
   Prints out the calendar for a given YEAR with WIDTH characters wide and
   with MARGIN spaces between months."
  ([]
     (print-cal 1969 80 2))
  ([year]
     (print-cal year 80 2))
  ([year width]
   (print-cal year width 2))
  ([year width margin]
     (assert (>= width (count day-row)) "Width should be more than 20.")
     (assert (> margin 0) "Margin needs to be more than 0.")
     (let [date (new java.util.GregorianCalendar year 0 1)
           column-count (calc-columns width margin)
           total-size (+ (* column-count (count day-row))
                         (* (dec column-count) margin))]
       (println (center-string "[Snoopy Picture]" total-size))
       (println (center-string (str year) total-size))
       (println)
       (print-months (year-vector date) column-count margin))))
