Program SumOFDigits;

function SumOfDigitBase(n:UInt64;base:LongWord): LongWord;
var
  tmp: Uint64;
  digit,sum : LongWord;
Begin
  digit := 0;
  sum   := 0;
  While n > 0 do
  Begin
    tmp := n div base;
    digit := n-base*tmp;
    n := tmp;
    inc(sum,digit);
  end;
  SumOfDigitBase := sum;
end;
Begin
  writeln('   1 sums to ', SumOfDigitBase(1,10));
  writeln('1234 sums to ', SumOfDigitBase(1234,10));
  writeln(' $FE sums to ', SumOfDigitBase($FE,16));
  writeln('$FOE sums to ', SumOfDigitBase($F0E,16));

  writeln('18446744073709551615 sums to ', SumOfDigitBase(High(Uint64),10));

end.
