; based on http://www.rosettacode.org/wiki/Sorting_algorithms/Quicksort#AutoHotkey
OidQuickSort(a, Delim:=".", index:=1){
    if (a.Count() <= 1)
        return a
    Less := [], Equal := [], More := []
    Pivot := StrSplit(a[1], Delim)[index]
    for k, v in a
    {
        x := StrSplit(v, Delim)[index]
        if (x < Pivot)
            less.InsertAt(1, v)
        else if (x > Pivot)
            more.InsertAt(1, v)
        else
            Equal.InsertAt(1, v)
    }
    Equal := OidQuickSort(Equal, Delim, index+1)
    Less  := OidQuickSort(Less)
    Out	  := OidQuickSort(More)
    if (Equal.Count())
        Out.InsertAt(1, Equal*)	; InsertAt all values of Equal at index 1
    if (Less.Count())
        Out.InsertAt(1, Less*)	; InsertAt all values of Less at index 1
    return Out
}
