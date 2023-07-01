(setq *PermList
   (mapcar chop
      (quote
         "ABCD" "CABD" "ACDB" "DACB" "BCDA" "ACBD" "ADCB" "CDAB"
         "DABC" "BCAD" "CADB" "CDBA" "CBAD" "ABDC" "ADBC" "BDCA"
         "DCBA" "BACD" "BADC" "BDAC" "CBDA" "DBCA" "DCAB" ) ) )

(let (Lst (chop "ABCD")  L Lst)
   (recur (L)  # Permute
      (if (cdr L)
         (do (length L)
            (recurse (cdr L))
            (rot L) )
         (unless (member Lst *PermList)  # Check
            (prinl Lst) ) ) ) )
