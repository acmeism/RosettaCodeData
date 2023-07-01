program fusc;
uses
  sysutils;
const
{$IFDEF FPC}
  MaxIdx = 1253 * 1000 * 1000; //19573420; // must be even
{$ELSE}
  // Dynamics arrays in Delphi cann't be to large
  MaxIdx = 19573420;
 {$ENDIF}

type
  tFuscElem = LongWord;
  tFusc = array of tFuscElem;
var
  FuscField : tFusc;

function commatize(n:NativeUint):string;
var
  l,i : NativeUint;
begin
  str(n,result);
  l := length(result);
  //no commatize
  if l < 4 then
    exit;
  //new length
  i := l+ (l-1) DIV 3;
  setlength(result,i);
  //copy chars to the right place
  While i <> l do
  Begin
    result[i]:= result[l];result[i-1]:= result[l-1];
    result[i-2]:= result[l-2];result[i-3]:= ',';
    dec(i,4);dec(l,3);
  end;
end;

procedure OutFusc(StartIdx,EndIdx :NativeInt;const FF:tFusc);
Begin
  IF StartIdx < Low(FF) then StartIdx :=Low(FF);
  IF EndIdx > High(FF) then EndIdx := High(FF);
  For StartIdx := StartIdx to EndIdx do
    write(FF[StartIdx],' ');
  writeln;
end;

procedure FuscCalc(var FF:tFusc);
var
  pFFn,pFFi : ^tFuscElem;
  i,n,sum : NativeUint;
Begin
  FF[0]:= 0;
  FF[1]:= 1;
  n := 2;
  i := 1;
  pFFn := @FF[n];
  pFFi := @FF[i];
  sum := pFFi^;
  while n <= MaxIdx-2 do
  begin
    //even
    pFFn^ := sum;//FF[n] := FF[i];
    //odd
    inc(pFFi);//FF[i+1]
    inc(pFFn);//FF[n+1]
    sum := sum+pFFi^;
    pFFn^:= sum; //FF[n+1] := FF[i]+FF[i+1];
    sum := pFFi^;
    inc(pFFn);
    inc(n,2);
    //inc(i);
  end;
end;

procedure OutHeader(base:NativeInt);
begin
  writeln('Fusc numbers with more digits in base ',base,' than all previous ones:');
  writeln('Value':10,'Index':10,'  IndexNum/IndexNumBefore');
  writeln('======':10,' =======':14);
end;

procedure CheckFuscDigits(const FF:tFusc;Base:NativeUint);
var
  pFF : ^tFuscElem;
  Dig,
  i,lastIdx: NativeInt;
Begin
  OutHeader(base);
  Dig := -1;
  i := 0;
  lastIdx := 0;
  pFF := @FF[0];// aka FF[i]
  repeat
    //search in tight loop speeds up
    repeat
      inc(pFF);
      inc(i);
    until pFF^ >Dig;

    if i>= MaxIdx then
      BREAK;
    //output
    write(commatize(pFF^):10,commatize(i):14);//,DIG:10);
    IF lastIdx> 0 then
      write(i/lastIdx:12:7);
    writeln;
    lastIdx := i;
    IF Dig >0 then
      Dig := Dig*Base+Base-1
    else
     Dig := Base-1;
  until false;
  writeln;
end;

BEGIN
  setlength(FuscField,MaxIdx);
  FuscCalc(FuscField);
  writeln('First 61 fusc numbers:');
  OutFusc(0,60,FuscField);

  CheckFuscDigits(FuscField,10);
  CheckFuscDigits(FuscField,11); //11 ~phi^5  1.6180..^5 = 11,09
  setlength(FuscField,0);
  {$IFDEF WIN}readln;{$ENDIF}
END.
