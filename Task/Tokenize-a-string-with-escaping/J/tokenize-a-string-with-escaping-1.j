tokenize1=: tokenize =: '^|'&$: :(4 : 0)
 'ESC SEP' =. x
 STATE =. 0
 RESULT =. 0 $ a:
 TOKEN =. ''
 for_C. y do.
  if. STATE do.
   TOKEN =. TOKEN , C
   STATE =. 0
  else.
   if. C = ESC do.
    STATE =. 1
   elseif. C = SEP do.
    RESULT =. RESULT , < TOKEN
    TOKEN =. ''
   elseif. do.
    TOKEN =. TOKEN , C
   end.
  end.
 end.
 RESULT =. RESULT , < TOKEN
)
