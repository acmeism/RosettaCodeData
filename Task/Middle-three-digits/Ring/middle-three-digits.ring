n = 1234567
middle(n)

func middle nr
     mnr = floor(len(string(nr))/2)
     lennr = len(string(nr))
     if lennr = 3 see "" + nr + nl
     but lennr < 3 see "Number must have at least three digits"
     but lennr%2=0 see "Number must have an odd number of digits"
     else cnr = substr(string(nr),mnr,3) see cnr + nl ok
