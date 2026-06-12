db =
(
1995-11-21|1995-11-21
2019-01-01|2019-01-02
2019-01-02|2019-01-01
2019-01-01|2019-03-01
2020-01-01|2020-03-01
1902-01-01|1968-12-25
2090-01-01|2098-12-25
1902-01-01|2098-12-25
)

for i, line in StrSplit(db, "`n", "`r"){
    D := StrSplit(line, "|")
    result .= "Days between " D.1 " and " D.2 "  :  " Days_between(D.1, D.2) " Day(s)`n"
}
MsgBox, 262144, , % result
return

Days_between(D1, D2){
    D1 := RegExReplace(D1, "\D")
    D2 := RegExReplace(D2, "\D")
    EnvSub, D2, % D1, days
    return D2
}
