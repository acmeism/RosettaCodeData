{
  split($1,a,"");
  for (i=1;i<=4;++i) {
    t[i,a[i]]++;
  }
}
END {
  for (k in t) {
    split(k,a,SUBSEP)
    for (l in t) {
      split(l, b, SUBSEP)
      if (a[1] == b[1] && t[k] < t[l]) {
        s[a[1]] = a[2]
        break
      }
    }
  }
  print s[1]s[2]s[3]s[4]
}
