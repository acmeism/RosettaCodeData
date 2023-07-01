# Heap’s algorithm for generating permutations. Algorithm 2 in
# Robert Sedgewick, 1977. Permutation generation methods. ACM
# Comput. Surv. 9, 2 (June 1977), 137-164.

define(n, 3)
define(n_minus_1, 2)

implicit none

integer a(1:n)

integer c(1:n)
integer i, k
integer tmp

10000 format ('(', I1, n_minus_1(' ', I1), ')')

# Initialize the data to be permuted.
do i = 1, n {
   a(i) = i
}

# What follows is a non-recursive Heap’s algorithm as presented by
# Sedgewick. Sedgewick neglects to fully initialize c, so I have
# corrected for that. Also I compute k without branching, by instead
# doing a little arithmetic.
do i = 1, n {
   c(i) = 1
}
i = 2
write (*, 10000) a
while (i <= n) {
   if (c(i) < i) {
      k = mod (i, 2) + ((1 - mod (i, 2)) * c(i))
      tmp = a(i)
      a(i) = a(k)
      a(k) = tmp
      c(i) = c(i) + 1
      i = 2
      write (*, 10000) a
   } else {
      c(i) = 1
      i = i + 1
   }
}

end
