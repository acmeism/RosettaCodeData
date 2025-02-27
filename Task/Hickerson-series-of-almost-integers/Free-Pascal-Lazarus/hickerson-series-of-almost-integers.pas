{$mode ObjFPC} {$H+}

Uses sysutils,math;

Function fact(n : integer): qword;
Begin
  If n <= 1 Then
    result := 1
  Else
    result := n * fact(n-1);
End;

Function hickerson(n : integer): extended;
Begin
  result := fact(n) / (2*power(ln(2),n+1));
End;

Function AlmostInteger(n : extended): boolean;

Var firstdec : integer;
Begin
  firstdec := trunc(n * 10) Mod 10;
  result := (firstdec = 0) Or (firstdec = 9);
End;

Var i : integer;
  hick : extended;

Begin
  For i := 1 To 17 Do
    Begin
      hick := hickerson(i);
      writeln('H(',i:2,') = ',hick:25:4,almostinteger(hick): 7);
    End;
End.
