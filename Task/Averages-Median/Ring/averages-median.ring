aList = [5,4,2,3]
see "medium : " + median(aList) + nl

func median aray
     srtd = sort(aray)
     alen = len(srtd)
     if alen % 2 = 0
        return (srtd[alen/2] + srtd[alen/2 + 1]) / 2.0
     else return srtd[ceil(alen/2)] ok
