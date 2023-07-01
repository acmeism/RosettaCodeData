seq := [1,2,3,4,5,6,7,8,9,10,11]
MsgBox % result := TPK(seq, 400)
return

TPK(s, num){
    for i, v in reverse(s)
        res .= v . " : " . ((x:=f(v)) > num ? "OVERFLOW" : x ) . "`n"
    return res
}
reverse(s){
    Loop % s.Count()
        s.InsertAt(A_Index, s.pop())
    return s
}
f(x){
    return Sqrt(x) + 5* (x**3)
}
