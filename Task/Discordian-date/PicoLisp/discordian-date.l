(de disdate (Year Month Day)
   (let? Date (date Year Month Day)
      (let (Leap (date Year 2 29)  D (- Date (date Year 1 1)))
         (if (and Leap (= 2 Month) (= 29 Day))
            (pack "St. Tib's Day, YOLD " (+ Year 1166))
            (and Leap (>= D 60) (dec 'D))
            (pack
               (get
                  '("Chaos" "Discord" "Confusion" "Bureaucracy" "The Aftermath")
                  (inc (/ D 73)) )
               " "
               (inc (% D 73))
               ", YOLD "
               (+ Year 1166) ) ) ) ) )
