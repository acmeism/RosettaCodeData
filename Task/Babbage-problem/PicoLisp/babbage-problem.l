: (for N 99736                               # Iterate N from 1 to 99736
   (T (= 269696 (% (* N N) 1000000)) N) )    # Stop if remainder is 269696
-> 25264
