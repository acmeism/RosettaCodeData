# Usage: awk -f reverse.awk -v s=Rosetta

function rev(s,   i,a,r) {
   split(s, a, "")
   for (i in a) r = a[i] r
   return r
}
BEGIN {
   if(!s) s = "Hello, world!"
   print s, "<-->", rev(s)
}
