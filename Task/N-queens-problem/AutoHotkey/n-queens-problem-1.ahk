;
; Post: http://www.autohotkey.com/forum/viewtopic.php?p=353059#353059
; Timestamp: 05/may/2010
;

MsgBox % funcNQP(5)
MsgBox % funcNQP(8)

Return

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; ** USED VARIABLES **
;
; Global: All variables named Array[???]
;
; Function funcNPQ: nQueens , OutText , qIndex
;
; Function Unsafe: nIndex , Idx , Tmp , Aux
;
; Function PutBoard: Output , QueensN , Stc , xxx , yyy
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

funcNQP(nQueens)
{
  Global
  Array[0] := -1
  Local OutText , qIndex := 0
  While ( qIndex >= 0 )
  {
    Array[%qIndex%]++
    While ( (Array[%qIndex%] < nQueens) && Unsafe(qIndex) )
      Array[%qIndex%]++
    If ( Array[%qIndex%] < nQueens )
    {
      If ( qIndex < nQueens-1 )
        qIndex++  ,  Array[%qIndex%] := -1
      Else
        PutBoard(OutText,nQueens)
    }
    Else
      qIndex--
  }
  Return OutText
}

;------------------------------------------

Unsafe(nIndex)
{
  Global
  Local Idx := 1  ,  Tmp := 0  ,  Aux := Array[%nIndex%]
  While ( Idx <= nIndex )
  {
    Tmp := "Array[" nIndex - Idx "]"
    Tmp := % %Tmp%
    If ( ( Tmp = Aux ) || ( Tmp = Aux-Idx ) || ( Tmp = Aux+Idx ) )
      Return 1
    Idx++
  }
  Return 0
}

;------------------------------------------

PutBoard(ByRef Output,QueensN)
{
  Global
  Static Stc = 0
  Local xxx := 0 , yyy := 0
  Output .= "`n`nSolution #" (++Stc) "`n"
  While ( yyy < QueensN )
  {
    xxx := 0
    While ( xxx < QueensN )
      Output .= ( "|" ( ( Array[%yyy%] = xxx ) ? "Q" : "_" ) )  ,  xxx++
    Output .= "|`n"  ,  yyy++
  }
}
