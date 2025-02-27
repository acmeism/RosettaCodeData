# determine and print all permutations of numbers 1..n

# General variant: simple, single array, recursive, not in lexical order
#
# An array with n places is used, marked by 0 as free.
# The current element l replaces the free places one by one,
# and the next element l+1 is probed recursively with the array.
#
function permute1(l, n, r,   i) {
  if ( l <= n) {
    for (i=1; i<=n; ++i) {
      if (r[i] == 0) {
        r[i] = l
        permute1(l+1, n, r)
        r[i] = 0
      }
    }
    return
  }
  # print result; consumes ca. 50% of CPU time
  s = ""
  for (i=1; i <= length(r); ++i)  # ensure order
    s = s r[i] " "
  print s
}

# command line parameter is number of elements.
BEGIN {
  n = 3                               # default
  if (ARGC > 1) n = ARGV[1]           # number may be given as parameter
  for (i=1; i <=n; ++i) r[i] = 0      # fill with zeroes
  permute1(1, n,  r)
}
