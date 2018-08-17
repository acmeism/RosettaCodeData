# Project : Map range

decimals(1)
al = 0
ah = 10
bl = -1
bh = 0
for n = 0 to 10
     see "" + n + " maps to " + maprange(al, bl, n) + nl
next

func maprange(al, bl, s)
       return bl + (s - al) * (bh - bl) / (ah - al)
