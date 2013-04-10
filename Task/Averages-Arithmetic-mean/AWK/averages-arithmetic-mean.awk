# work around a gawk bug in the length extended use:
# so this is a more non-gawk compliant way to get
# how many elements are in an array
function elength(v)
{
  l=0
  for(el in v) l++
  return l
}

function mean(v)
{
  if (elength(v) < 1) { return 0 }
  sum = 0
  for(i=0; i < elength(v); i++) {
    sum += v[i]
  }
  return sum/elength(v)
}

BEGIN {
  # fill a vector with random numbers
  for(i=0; i < 10; i++) {
    vett[i] = rand()*10
  }
  print mean(vett)
}
