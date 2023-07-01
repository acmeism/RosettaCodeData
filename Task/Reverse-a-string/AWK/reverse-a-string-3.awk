# Usage: awk -f reverse.awk -v s=Rosetta

function rev(s,   i,len,a,r) {
   len = split(s, a, "")
  #for (i in a) r = a[i] r	# may not work - order is not guaranteed !
   for (i=1; i<=len; i++) r = a[i] r
   return r
}
BEGIN {
   if(!s) s = "Hello, world!"
   print s, "<-->", rev(s)
}
