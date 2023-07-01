$ jq -r -n -f Pascal_matrix_generation.jq

Upper:

   1   1   1   1   1
   0   1   2   3   4
   0   0   1   3   6
   0   0   0   1   4
   0   0   0   0   1

Lower:

   1   0   0   0   0
   1   1   0   0   0
   1   2   1   0   0
   1   3   3   1   0
   1   4   6   4   1

Symmetric:

   1   1   1   1   1
   1   2   3   4   5
   1   3   6  10  15
   1   4  10  20  35
   1   5  15  35  70
