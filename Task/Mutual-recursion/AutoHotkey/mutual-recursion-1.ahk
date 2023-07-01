Loop 20
   i := A_Index-1, t .= "`n" i "`t   " M(i) "`t     " F(i)
MsgBox x`tmale`tfemale`n%t%

F(n) {
   Return n ? n - M(F(n-1)) : 1
}

M(n) {
   Return n ? n - F(M(n-1)) : 0
}
