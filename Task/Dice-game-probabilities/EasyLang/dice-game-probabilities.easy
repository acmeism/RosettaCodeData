proc throw_die n_sides n_dice s &counts[] .
   if n_dice = 0
      counts[s] += 1
      return
   .
   for i = 1 to n_sides
      throw_die n_sides (n_dice - 1) (s + i) counts[]
   .
.
func proba n_sides1 n_dice1 n_sides2 n_dice2 .
   len c1[] (n_sides1 + 1) * n_dice1
   len c2[] (n_sides2 + 1) * n_dice2
   throw_die n_sides1 n_dice1 0 c1[]
   throw_die n_sides2 n_dice2 0 c2[]
   p12 = pow n_sides1 n_dice1 * pow n_sides2 n_dice2
   for i = 1 to len c1[]
      for j = 1 to lower (i - 1) len c2[]
         tot += c1[i] * c2[j] / p12
      .
   .
   return tot
.
numfmt 0 5
print proba 4 9 6 6
print proba 10 5 7 6
