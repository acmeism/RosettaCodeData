function permute(l, k,   i, s) {
  if (k == length(l)) {
    show(s)
    return
  }
  for (i=k; i <= length(l); ++i) {
    swap(l, i, k)
    permute(l, k+1)
    swap(l, k, i)
  }
}
function swap(l, i, k,    t) {
  t = l[i]
  l[i] = l[k]
  l[k] = t
}
BEGIN {
  n = 3                               # default
  if (ARGC > 1) n = ARGV[1]           # number may be given as parameter
  for (i=1; i <=n; ++i)
    l[i] = i
  permute(l, 1)
  }
