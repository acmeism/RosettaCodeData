(in "data.csv"
   (prinl (line) "," "SUM")
   (while (split (line) ",")
      (prinl (glue "," @) "," (sum format @)) ) )
