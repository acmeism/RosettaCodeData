program SexyPrimes;

uses
  SysUtils
{$IFNDEF FPC}
 ,windows // GettickCount64
{$ENDIF}

const
  ctext: array[0..5] of string = ('Primes',
    'sexy prime pairs',
    'sexy prime triplets',
    'sexy prime quadruplets',
    'sexy prime quintuplet',
    'sexy prime sextuplet');

  primeLmt = 1000 * 1000 + 35;
type
  sxPrtpl = record
    spCnt,
    splast5Idx: nativeInt;
    splast5: array[0..6] of NativeInt;
  end;

var
  sieve: array[0..primeLmt] of byte;
  sexyPrimesTpl: array[0..5] of sxPrtpl;
  unsexyprimes: NativeUint;

  procedure dosieve;
  var
    p, delPos, fact: NativeInt;
  begin
    p := 2;
    repeat
      if sieve[p] = 0 then
      begin
        delPos := primeLmt div p;
        if delPos < p then
          BREAK;
        fact := delPos * p;
        while delPos >= p do
        begin
          if sieve[delPos] = 0 then
            sieve[fact] := 1;
          Dec(delPos);
          Dec(fact, p);
        end;
      end;
      Inc(p);
    until False;
  end;
  procedure CheckforSexy;
  var
    i, idx, sieveMask, tstMask: NativeInt;
  begin
    sieveMask := -1;
    for i := 2 to primelmt do
    begin
      tstMask := 1;
      sieveMask := sieveMask + sieveMask + sieve[i];
      idx := 0;
      repeat
        if (tstMask and sieveMask) = 0 then
          with sexyPrimesTpl[idx] do
          begin
            Inc(spCnt);
            //memorize the last entry
            Inc(splast5idx);
            if splast5idx > 5 then
              splast5idx := 1;
            splast5[splast5idx] := i;
            tstMask := tstMask shl 6 + 1;
          end
        else
        begin
          BREAK;
        end;
        Inc(idx);
      until idx > 5;
    end;
  end;

  procedure CheckforUnsexy;
  var
    i: NativeInt;
  begin
    for i := 2 to 6 do
    begin
      if (Sieve[i] = 0) and (Sieve[i + 6] = 1) then
        Inc(unsexyprimes);
    end;
    for i := 2 + 6 to primelmt - 6 do
    begin
      if (Sieve[i] = 0) and (Sieve[i - 6] = 1) and (Sieve[i + 6] = 1) then
        Inc(unsexyprimes);
    end;
  end;

  procedure OutLast5(idx: NativeInt);
  var
    i, j, k: nativeInt;
  begin
    with sexyPrimesTpl[idx] do
    begin
      writeln(cText[idx], '  ', spCnt);
      i := splast5idx + 1;
      for j := 1 to 5 do
      begin
        if i > 5 then
          i := 1;
        if splast5[i] <> 0 then
        begin
          Write('[');
          for k := idx downto 1 do
            Write(splast5[i] - k * 6, ' ');
          Write(splast5[i], ']');
        end;
        Inc(i);
      end;
    end;
    writeln;
  end;

  procedure OutLastUnsexy(cnt:NativeInt);
  var
    i: NativeInt;
    erg: array of NativeUint;
  begin
    if cnt < 1 then
      EXIT;
    setlength(erg,cnt);
    dec(cnt);
    if cnt < 0 then
      EXIT;
    for i := primelmt downto 2 + 6 do
    begin
      if (Sieve[i] = 0) and (Sieve[i - 6] = 1) and (Sieve[i + 6] = 1) then
      Begin
        erg[cnt] := i;
        dec(cnt);
        If cnt < 0 then
          BREAK;
       end;
    end;
    write('the last ',High(Erg)+1,' unsexy primes ');
    For i := 0 to High(erg)-1 do
      write(erg[i],',');
    write(erg[High(erg)]);
  end;
var
  T1, T0: int64;
  i: nativeInt;

begin

  T0 := GettickCount64;
  dosieve;
  T1 := GettickCount64;
  writeln('Sieving is done in ', T1 - T0, ' ms');
  T0 := GettickCount64;
  CheckforSexy;
  T1 := GettickCount64;
  writeln('Checking is done in ', T1 - T0, ' ms');

  unsexyprimes := 0;
  T0 := GettickCount64;
  CheckforUnsexy;
  T1 := GettickCount64;
  writeln('Checking unsexy is done in ', T1 - T0, ' ms');

  writeln('Limit : ', primelmt);
  for i := 0 to 4 do
  begin
    OutLast5(i);
  end;
  writeln;
  writeln(unsexyprimes,' unsexy primes');
  OutLastUnsexy(10);
end.
