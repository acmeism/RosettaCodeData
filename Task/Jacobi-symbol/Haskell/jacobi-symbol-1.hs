jacobi :: Integer -> Integer -> Integer
jacobi 0 1 = 1
jacobi 0 _ = 0
jacobi a n =
  let a_mod_n = rem a n
  in if even a_mod_n
       then case rem n 8 of
              1 -> jacobi (div a_mod_n 2) n
              3 -> negate $ jacobi (div a_mod_n 2) n
              5 -> negate $ jacobi (div a_mod_n 2) n
              7 -> jacobi (div a_mod_n 2) n
       else if rem a_mod_n 4 == 3 && rem n 4 == 3
              then negate $ jacobi n a_mod_n
              else jacobi n a_mod_n
