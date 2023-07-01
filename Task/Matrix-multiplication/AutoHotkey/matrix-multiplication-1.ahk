Matrix("b","  ; rows separated by ","
, 1   2       ; entries separated by space or tab
, 2   3
, 3   0")
MsgBox % "B`n`n" MatrixPrint(b)
Matrix("c","
, 1 2 3
, 3 2 1")
MsgBox % "C`n`n" MatrixPrint(c)

MatrixMul("a",b,c)
MsgBox % "B * C`n`n" MatrixPrint(a)

MsgBox % MatrixMul("x",b,b)


Matrix(_a,_v) { ; Matrix structure: m_0_0 = #rows, m_0_1 = #columns, m_i_j = element[i,j], i,j > 0
   Local _i, _j = 0
   Loop Parse, _v, `,
      If (A_LoopField != "") {
         _i := 0, _j ++
         Loop Parse, A_LoopField, %A_Space%%A_Tab%
            If (A_LoopField != "")
               _i++, %_a%_%_i%_%_j% := A_LoopField
      }
   %_a% := _a, %_a%_0_0 := _j, %_a%_0_1 := _i
}
MatrixPrint(_a) {
   Local _i = 0, _t
   Loop % %_a%_0_0 {
      _i++
      Loop % %_a%_0_1
         _t .= %_a%_%A_Index%_%_i% "`t"
      _t .= "`n"
   }
   Return _t
}
MatrixMul(_a,_b,_c) {
   Local _i = 0, _j, _k, _s
   If (%_b%_0_0 != %_c%_0_1)
      Return "ERROR: inner dimensions " %_b%_0_0 " != " %_c%_0_1
   %_a% := _a, %_a%_0_0 := %_b%_0_0, %_a%_0_1 := %_c%_0_1
   Loop % %_c%_0_1 {
      _i++, _j := 0
      Loop % %_b%_0_0 {
         _j++, _k := _s := 0
         Loop % %_b%_0_1
            _k++, _s += %_b%_%_k%_%_j% * %_c%_%_i%_%_k%
         %_a%_%_i%_%_j% := _s
      }
   }
}
