(setq *States
   (group
      (mapcar '((Name) (cons (clip (sort (chop (lowc Name)))) Name))
         (quote
            "Alabama" "Alaska" "Arizona" "Arkansas"
            "California" "Colorado" "Connecticut"
            "Delaware"
            "Florida" "Georgia" "Hawaii"
            "Idaho" "Illinois" "Indiana" "Iowa"
            "Kansas" "Kentucky" "Louisiana"
            "Maine" "Maryland" "Massachusetts" "Michigan"
            "Minnesota" "Mississippi" "Missouri" "Montana"
            "Nebraska" "Nevada" "New Hampshire" "New Jersey"
            "New Mexico" "New York" "North Carolina" "North Dakota"
            "Ohio" "Oklahoma" "Oregon"
            "Pennsylvania" "Rhode Island"
            "South Carolina" "South Dakota" "Tennessee" "Texas"
            "Utah" "Vermont" "Virginia"
            "Washington" "West Virginia" "Wisconsin" "Wyoming"
            "New Kory" "Wen Kory" "York New" "Kory New" "New Kory" ) ) ) )

(extract
   '((P)
      (when (cddr P)
         (mapcar
            '((X)
               (cons
                  (cadr (assoc (car X) *States))
                  (cadr (assoc (cdr X) *States)) ) )
            (cdr P) ) ) )
   (group
      (mapcon
         '((X)
            (extract
               '((Y)
                  (cons
                     (sort (conc (copy (caar X)) (copy (car Y))))
                     (caar X)
                     (car Y) ) )
               (cdr X) ) )
         *States ) ) )
