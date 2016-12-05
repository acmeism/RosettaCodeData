list = "ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB"

for a = ascii("A") to ascii("D")
    for b = ascii("A") to ascii("D")
        for c = ascii("A") to ascii("D")
            for d = ascii("A") to ascii("D")
                x = char(a) + char(b) + char(c)+ char(d)
                if a!=b and a!=c and a!=d and b!=c and b!=d and c!=d
                   if substr(list,x) = 0 see x + " missing" + nl ok ok
            next
        next
    next
next
