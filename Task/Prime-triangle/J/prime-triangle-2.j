task=: {{
  for_j.2}.i.1+y do.
    N=. #seqs=. prime_pair_seqs j
    echo (_8{.":N),' | ',3":{:seqs
  end.
}}

   task 20
       1 |   1  2
       1 |   1  2  3
       1 |   1  2  3  4
       1 |   1  4  3  2  5
       1 |   1  4  3  2  5  6
       2 |   1  6  5  2  3  4  7
       4 |   1  6  7  4  3  2  5  8
       7 |   1  6  7  4  3  8  5  2  9
      24 |   1  6  7  4  9  8  5  2  3 10
      80 |   1 10  9  8  5  6  7  4  3  2 11
     216 |   1 10  9  8 11  6  7  4  3  2  5 12
     648 |   1 12 11  8  9 10  7  6  5  2  3  4 13
    1304 |   1 12 11  8  9 10 13  6  7  4  3  2  5 14
    3392 |   1 12 11  8  9 14  5  6 13 10  7  4  3  2 15
   13808 |   1 12 11  8 15 14  9 10 13  6  5  2  3  4  7 16
   59448 |   1 16 15 14  9 10 13  6 11 12  7  4  3  8  5  2 17
  155464 |   1 16 15 14 17 12 11  8  9 10 13  6  7  4  3  2  5 18
  480728 |   1 18 13 16 15 14 17 12 11  8  9 10  7  6  5  2  3  4 19
 1588162 |   1 18 19 12 17 14 15 16 13 10  9  8 11  2  5  6  7  4  3 20
