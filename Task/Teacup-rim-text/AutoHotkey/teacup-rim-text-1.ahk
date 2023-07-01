Teacup_rim_text(wList){
    oWord := [], oRes := [], n := 0
    for i, w in StrSplit(wList, "`n", "`r")
        if StrLen(w) >= 3
            oWord[StrLen(w), w] := true

    for l, obj in oWord
    {
        for w, bool in obj
        {
            loop % l
                if oWord[l, rotate(w)]
                {
                    oWord[l, w] := 0
                    if (A_Index = 1)
                        n++, oRes[n] := w
                    if (A_Index < l)
                        oRes[n] := oRes[n] "," (w := rotate(w))
                }
            if (StrSplit(oRes[n], ",").Count() <> l)
                oRes.RemoveAt(n)
        }
    }
    return oRes
}

rotate(w){
    return SubStr(w, 2) . SubStr(w, 1, 1)
}
