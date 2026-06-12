oDays := ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
oColors := ["Red","Orange","Yellow","Green","Blue","Purple"]
MsgBox % Result := ""
	. "All elements:`n"                            Iterators(oDays)                "`n" Iterators(oColors)
	. "`n`nFirst, fourth, and fifth:`n"            Iterators(oDays, [1,4,5])        "`n" Iterators(oColors, [1,4,5])
	. "`n`nReverse first, fourth, and fifth:`n"    Iterators(oDays, [1,4,5], 1)    "`n" Iterators(oColors, [1,4,5], 1)
return

Iterators(obj, num:="", rev:=0){
    for i, v in (num.Count() ? num : obj)
        res .= (rev ? obj[obj.Count() +1 -v] : num.Count() ? obj[v] : v) ", "
    return Trim(res, ", ") "."
}
