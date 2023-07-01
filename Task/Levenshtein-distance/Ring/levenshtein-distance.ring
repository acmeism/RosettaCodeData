# Project : Levenshtein distance

load "stdlib.ring"
see "" + "distance(kitten, sitting) = " + levenshteindistance("kitten", "sitting") + nl
see "" + "distance(saturday, sunday) = " + levenshteindistance("saturday", "sunday") + nl
see "" + "distance(rosettacode, raisethysword) = " + levenshteindistance("rosettacode", "raisethysword") + nl

func levenshteindistance(s1, s2)
        n = len(s1)
        m = len(s2)
        if n = 0
            levenshteindistance = m
            return
        ok
        if m = 0
            levenshteindistance = n
            return
        ok
        d = newlist(n, m)
        for i = 1 to n
             d[i][1] = i
        next i
        for i = 1 to m
             d[1][i] = i
        next
        for i = 2 to n
             si = substr(s1, i, 1)
             for j = 2 to m
                  tj = substr(s2, j, 1)
                  if si = tj
                     cost = 0
                  else
                     cost = 1
                  ok
                  d[i][ j] = min((d[i - 1][ j]), min((d[i][j - 1] + 1), (d[i - 1][j - 1] + cost)))
             next
        next
        levenshteindistance = d[n][m]
        return levenshteindistance
