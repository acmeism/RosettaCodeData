#!/usr/bin/awk -f
BEGIN {
   if (p<1) {p = 1};
}

function diff(s, p) {
   n = split(s, a, " ");
   for (j = 1; j <= p; j++) {
      for(i = 1; i <= n-j; i++) {
         a[i] = a[i+1] - a[i];
      }
   }
   s = "";
   for (i = 1; i <= n-p; i++) s = s" "a[i];
   return s;	
}

{
   print diff($0, p);
}
