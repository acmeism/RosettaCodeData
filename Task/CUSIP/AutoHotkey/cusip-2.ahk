data =
(
037833100
17275R102
38259P508
594918104
68389X106
68389X105
)

output := "Cusip`t`tValid`n"
loop, Parse, data, `n, `r
    output .= A_LoopField "`t" Cusip_Check_Digit(A_LoopField) "`n"
MsgBox % output
