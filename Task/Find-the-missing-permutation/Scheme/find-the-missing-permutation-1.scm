(use gauche.collection)

(define *permutations*
  '("ABCD" "CABD" "ACDB" "DACB" "BCDA" "ACBD" "ADCB" "CDAB"
    "DABC" "BCAD" "CADB" "CDBA" "CBAD" "ABDC" "ADBC" "BDCA"
    "DCBA" "BACD" "BADC" "BDAC" "CBDA" "DBCA" "DCAB"))

(apply string
  (map (^c (car (find-min c :key length)))
    (map group-collection
      (apply map list (map string->list *permutations*)))))

"DBAC"
