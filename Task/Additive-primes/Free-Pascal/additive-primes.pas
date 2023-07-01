Program AdditivePrimes;
Const max_number = 500;

Var is_prime : array Of Boolean;

Procedure sieve(Var arr: Array Of boolean );
{use Sieve of Eratosthenes to find all primes to max number}
Var i,j : NativeUInt;

Begin
  For i := 2 To high(arr) Do
    arr[i] := True;  // set all bits to be True
  For i := 2 To high(arr) Do
    Begin
      If (arr[i]) Then
        For j := 2 To (high(arr) Div i) Do
          arr[i * j] := False;
    End;
End;

Function GetSumOfDigits(num: NativeUInt): longint;
{calcualte the sum of digits of a number}
Var
  sum  : longint = 0;
  dummy: NativeUInt;
Begin
  Repeat
    dummy := num;
    num := num Div 10;
    Inc(sum, dummy - (num SHL 3 + num SHL 1));
  Until num < 1;
  GetSumOfDigits := sum;
End;

Var x : NativeUInt = 2; {first prime}
  counter : longint = 0;
Begin
  setlength(is_prime,max_number); //set length of array to max_number
  Sieve(is_prime); //apply Sieve

  {since 2 is the only even prime, let's do it separate}
  If is_prime[x] And is_prime[GetSumOfDigits(x)] Then
    Begin
      write(x:4);
      inc(counter);
    End;
  inc(x);
  While x < max_number Do
    Begin
      If is_prime[x] And is_prime[GetSumOfDigits(x)] Then
        Begin
          if counter mod 10 = 0 then writeln();
          write(x:4);
          inc(counter);
        End;
      inc(x,2);
    End;
  writeln();
  writeln();
  writeln(counter,' additive primes found.');
End.
