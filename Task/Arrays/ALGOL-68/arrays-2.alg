DEF ai[100] : ARRAY OF CHAR, -> static
    da: PTR TO CHAR,
    la: PTR TO CHAR

PROC main()
  da := New(100)
  -> or
  NEW la[100]
  IF da <> NIL
    ai[0] := da[0]    -> first is 0
    ai[99] := da[99]  -> last is "size"-1
    Dispose(da)
  ENDIF
  -> using NEW, we must specify the size even when
  -> "deallocating" the array
  IF la <> NIL THEN END la[100]
ENDPROC
