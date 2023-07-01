(de same (List)
  (apply = List))

(de sorted (List)
  (apply < List))

(de sorted-backwards (List)
  (apply > List))

(same '("AA" "AA" "AA"))
-> T
