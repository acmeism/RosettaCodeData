func tm2deg t$ .
   t[] = number strsplit t$ ":"
   return 360 * t[1] / 24.0 + 360 * t[2] / (24 * 60.0) + 360 * t[3] / (24 * 3600.0)
.
func$ deg2tm deg .
   len t[] 3
   h = floor (24 * 60 * 60 * deg / 360)
   t[3] = h mod 60
   h = h div 60
   t[2] = h mod 60
   t[1] = h div 60
   for h in t[]
      if h < 10
         s$ &= 0
      .
      s$ &= h
      s$ &= ":"
   .
   return substr s$ 1 8
.
func mean ang[] .
   for ang in ang[]
      x += cos ang
      y += sin ang
   .
   return atan2 (y / len ang[]) (x / len ang[])
.
in$ = "23:00:17 23:40:20 00:12:45 00:17:19"
for s$ in strsplit in$ " "
   ar[] &= tm2deg s$
.
print deg2tm (360 + mean ar[])
