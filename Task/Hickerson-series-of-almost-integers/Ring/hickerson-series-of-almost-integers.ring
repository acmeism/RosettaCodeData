n = 12
hick = 0
decimals(8)

for i = 1 to n
    see "h(" + string(i) + ") = "
    see "" + hickersonSeries(i) + " "
    if nearly(hick) = 1 see "nearly integer" + nl
    else see "not nearly integer" + nl ok
next

func hickersonSeries nr
     hick =  fact(nr) / (2 * pow(log(2), nr+1))
     return hick

func fact nr if nr = 1 return 1 else return nr * fact(nr-1) ok

func nearly nr
     strNr = string(nr)
     sub = substr(strNr,".")
     sub2 = substr(strNr,sub+1,1)
     if (sub2 = "0" or sub2="9") return 1
     else return 0 ok
     return sub
