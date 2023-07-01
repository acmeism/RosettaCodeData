UPC2Dec(code){
    lBits :={"   ## #":0,"  ##  #":1,"  #  ##":2," #### #":3," #   ##":4," ##   #":5," # ####":6," ### ##":7," ## ###":8,"   # ##":9}
    xlBits:={"# ##   ":0,"#  ##  ":1,"##  #  ":2,"# #### ":3,"##   # ":4,"#   ## ":5,"#### # ":6,"## ### ":7,"### ## ":8,"## #   ":9}
    rBits :={"###  # ":0,"##  ## ":1,"## ##  ":2,"#    # ":3,"# ###  ":4,"#  ### ":5,"# #    ":6,"#   #  ":7,"#  #   ":8,"### #  ":9}
    xrBits:={" #  ###":0," ##  ##":1,"  ## ##":2," #    #":3,"  ### #":4," ###  #":5,"    # #":6,"  #   #":7,"   #  #":8,"  # ###":9}
    UPC := "", CD := 0,	code := Trim(code, " ")
    S := SubStr(code, 1, 3), code := SubStr(code, 4)			; start or "upside down" end sequence
    loop 6
        C := SubStr(code, 1, 7), code := SubStr(code, 8)		; six left hand or "upside down" right hand digits
        , UPC := lBits[C] <> "" ? UPC . lBits[C] : xrBits[C] . UPC
    M := SubStr(code, 1, 5), code := SubStr(code, 6)			; middle sequence
    loop 6
        C := SubStr(code, 1, 7), code := SubStr(code, 8)		; six right hand or "upside down" left hand digits
        , UPC := rBits[C] <> "" ? UPC . rBits[C] : xlBits[C] . UPC
    E := SubStr(code, 1, 3), code := SubStr(code, 4)			; end or "upside down" start sequence
    for k, v in StrSplit(UPC)
        CD += Mod(A_Index, 2) ? v*3 : v					; Check Digit
    if (S <> "# #") || (M <> " # # ") || (E <> "# #") || Mod(CD, 10)
        return "Invalid!"
    return UPC
}
