(scl 3)

(setq *Compass                      # Build lookup table
   (let H -16.875
      (mapcar
         '((Str)
            (cons
               (inc 'H 11.25)       # Heading in degrees
               (pack                # Compass point
                  (replace (chop Str)
                     "N" "north"
                     "E" "east"
                     "S" "south"
                     "W" "west"
                     "b" " by " ) ) ) )
         '("N" "NbE" "N-NE" "NEbN" "NE" "NEbE" "E-NE" "EbN"
            "E" "EbS" "E-SE" "SEbE" "SE" "SEbS" "S-SE" "SbE"
            "S" "SbW" "S-SW" "SWbS" "SW" "SWbW" "W-SW" "WbS"
            "W" "WbN" "W-NW" "NWbW" "NW" "NWbN" "N-NW" "NbW"
            "N" ) ) ) )

(de heading (Deg)
   (rank (% Deg 360.00) *Compass) )

(for I (range 0 32)
   (let H (* I 11.25)
      (case (% I 3)
         (1 (inc 'H 5.62))
         (2 (dec 'H 5.62)) )
      (tab (3 1 -18 8)
         (inc (% I 32))
         NIL
         (cdr (heading H))
         (round H 2) ) ) )
