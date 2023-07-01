rem1 = 0
rem2 = 0
rem3 = 0
rem4 = 0
rem5 = 0
fn1 = [15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43]
fn2 = [36, 40, 7, 39, 41, 15]
fn3 = [0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594,
      0.73438555, -0.03035726, 1.46675970, -0.74621349, -0.72588772,
      0.63905160, 0.61501527, -0.98983780, -1.00447874, -0.62759469,
      0.66206163, 1.04312009, -0.10305385, 0.75775634, 0.32566578]
decimals(1)
fivenum(fn1) showarray([rem1,rem2,rem3,rem4,rem5])
fivenum(fn2) showarray([rem1,rem2,rem3,rem4,rem5])
decimals(8)
fivenum(fn3) showarray([rem1,rem2,rem3,rem4,rem5])

func median(table,low,high)
     l = high-low+1
     m = low + floor(l/2)
     if l%2 = 1
         return table[m]
     ok
     return (table[m-1]+table[m])/2

func fivenum(table)
     table = sort(table)
     low   = len(table)
     m     = floor(low/2)+low%2
     rem1  = table[1]
     rem2  = median(table,1,m)
     rem3  = median(table,1,low)
     rem4  = median(table,m+1,low)
     rem5  = table[low]
     return [rem1, rem2, rem3, rem4, rem5]

func showarray vect
     svect = ""
     for n in vect
         svect += " " + n + ","
     next
     ? "[" + left(svect, len(svect) - 1) + "]"
