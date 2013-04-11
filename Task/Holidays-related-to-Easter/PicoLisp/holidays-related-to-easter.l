(load "@lib/cal.l")  # For 'easter' function

(de dayMon (Dat)
   (let D (date Dat)
      (list (day Dat *Day) " " (align 2 (caddr D)) " " (get *Mon (cadr D))) ) )

(for Y (append (range 400 2100 100) (range 2010 2020))
   (let E (easter Y)
      (prinl
         (align 4 Y)
         " Easter: " (dayMon E)
         ", Ascension: " (dayMon (+ E 39))
         ", Pentecost: " (dayMon (+ E 49))
         ", Trinity: " (dayMon (+ E 56))
         ", Corpus: " (dayMon (+ E 60)) ) ) )
