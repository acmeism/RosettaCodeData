load "stdlib.ring"
decimals(8)
maxperiod = 20
nums = newlist(maxperiod,maxperiod)
accum = list(maxperiod)
index = list(maxperiod)
window = list(maxperiod)
for i = 1 to maxperiod
    index[i] = 1
    accum[i] = 0
    window[i] = 0
next
for i = 1 to maxperiod
    for j = 1 to maxperiod
        nums[i][j] = 0
    next
next
for n = 1 to 5
    see "number = " + n + "  sma3 = " + left((string(sma(n,3)) + "        "),9) + "  sma5 = " + sma(n,5) + nl
next
for n = 5 to 1 step -1
    see "number = " + n + "  sma3 = " + left((string(sma(n,3)) + "        "),9) + "  sma5 = " + sma(n,5) + nl
next
see nl

func sma number, period
     accum[period] += number - nums[period][index[period]]
     nums[period][index[period]] = number
     index[period]= (index[period] + 1) % period + 1
     if window[period]<period window[period] += 1 ok
     return (accum[period] / window[period])
