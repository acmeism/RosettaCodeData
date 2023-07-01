Program listArguments(input, output, stdErr);

Var
  i: integer;
Begin
  writeLn('program was called from: ',paramStr(0));
  For i := 1 To paramCount() Do
    Begin
      writeLn('argument',i:2,' : ', paramStr(i));
    End;
End.
