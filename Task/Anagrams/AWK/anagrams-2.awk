#!/bin/gawk -f

{   patsplit($0, chars, ".")
    asort(chars)
    sorted = ""
    for (i = 1; i <= length(chars); i++)
	sorted = sorted chars[i]

    if (++count[sorted] > countMax) countMax++
    accum[sorted] = accum[sorted] " " $0
}

END {
    for (i in accum)
	if (count[i] == countMax)
	    print substr(accum[i], 2)
}
