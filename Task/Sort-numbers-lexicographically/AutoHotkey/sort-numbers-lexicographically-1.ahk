n2lexicog(n){
    Arr := [], list := ""
    loop % n
        list .= A_Index "`n"
    Sort, list
    for k, v in StrSplit(Trim(list, "`n"), "`n")
        Arr.Push(v)
    return Arr
}
