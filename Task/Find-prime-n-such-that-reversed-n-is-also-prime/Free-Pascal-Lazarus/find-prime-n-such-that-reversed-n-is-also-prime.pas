Type Tboolarr = array Of boolean;

Const MAX = 1000;
Function SieveOfEratosthenes(limit: Integer): Tboolarr;
Var
  sieve: Tboolarr;
  i, j: Integer;
Begin
  SetLength(sieve, limit + 1);
  sieve[2] := True;
  For i := 3 To limit Do
    sieve[i] := (i Mod 2 <> 0);
  For i := 3 To Trunc(Sqrt(limit)) Do
    Begin
      If sieve[i] Then
        Begin
          j := i * i;
          While j <= limit Do
            Begin
              sieve[j] := False;
              Inc(j, 2 * i);
            End;
        End;
    End;
  SieveOfEratosthenes := sieve;
End;

Function ReverseNumber(number: Integer): Integer;
Var
  reversed: Integer;
Begin
  reversed := 0;
  While number <> 0 Do
    Begin
      reversed := reversed * 10 + (number Mod 10);
      number := number Div 10;
    End;
  ReverseNumber := reversed;
End;

Var
  primes: Tboolarr;
  i: Integer;
Begin
  primes := SieveOfEratosthenes(MAX);
  For i := 2 To 500 Do
    Begin
      If primes[i] And Primes[ReverseNumber(i)] Then
        Write(i,' ');
    End;
End.
