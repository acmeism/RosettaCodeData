(de ibEeaC (File . Prg)
   (let
      (Cie (let N 0 (in File (while (from "cie") (run Prg))))
         Nie (let N 0 (in File (while (from "ie") (run Prg))))
         Cei (let N 0 (in File (while (from "cei") (run Prg))))
         Nei (let N 0 (in File (while (from "ei") (run Prg)))) )
      (prinl "cie: " Cie)
      (prinl "nie: " (dec 'Nie Cie))
      (prinl "cei: " Cei)
      (prinl "nei: " (dec 'Nei Cei))
      (let (NotI (> (* 3 Cie) Nie)  NotE (> Nei (* 3 Cei)))
         (prinl
            "I before E except after C: is"
            (and NotI " not")
            " plausible" )
         (prinl
            "E before I when after C: is"
            (and NotE " not")
            " plausible" )
         (prinl
            "Overall rule is"
            (and (or NotI NotE) " not")
            " plausible" ) ) ) )

(ibEeaC "unixdict.txt"
   (inc 'N) )

(prinl)

(ibEeaC "1_2_all_freq.txt"
   (inc 'N (format (stem (line) "\t"))) )
