program UpSideDownNumbers;
{$IFDEF FPC}{$MODE DELPHI}{$Optimization ON,All}{$ENDIF}
{$IFDEF Windows}{$APPTYPE CONSOLE}{$ENDIF}
//count of UpSideDownNumbers until dgt
//1,+1,+9,+9,+9*9,+9*9,+9*9*9,...
const TotalCnt_Dgt : array[0..41] of Uint64=
  (1,2,11,20,101,182,911,1640,8201,14762,73811,132860,664301,1195742,
   5978711,10761680,53808401,96855122,484275611,871696100,4358480501,
   7845264902,39226324511,70607384120,353036920601,635466457082,
   3177332285411,5719198113740,28595990568701,51472783023662,
   257363915118311,463255047212960,2316275236064801,4169295424916642,
   20846477124583211,37523658824249780,187618294121248901,
   337712929418248022,1688564647091240111,3039416364764232200,
   15197081823821161001,HIGH(UINT64));
type
  tUpDown = record
              UD_half : array[0..21] of Int32;
              UD_Dgt  : Int32;
            end;

function EmitUpDownNumber(const UD :tUpDown):Ansistring;
var
  i,dc,idx : Int32;
begin
  with UD do
  Begin
    dc := UD_Dgt;
    setlength(result,dc);
    dc := dc shr 1 -1;
    idx := 1;
    For i := dc downto 0 do
    Begin
      result[idx] := chr(UD_half[i]+Ord('0'));
      inc(idx);
    end;
    if Odd(UD_Dgt) then
    Begin
      result[idx] := '5';
      inc(idx);
    end;
    For i := 0 to dc do
    Begin
      result[idx] := chr(10+Ord('0')-UD_half[i]);
      inc(idx);
    end;
  end;
end;

procedure NthUpDownNumber(n : Uint64;var UD:tUpDown);
var
  dgtCnt,i : Int32;
begin
  dgtCnt := 1;
  while (dgtCnt<= High(TotalCnt_Dgt)) AND (n>= TotalCnt_Dgt[dgtCnt]) do
    inc(dgtCnt);
  with UD do
  begin
    UD_Dgt := dgtCnt;
    n -= TotalCnt_Dgt[dgtCnt-1];
    if dgtCnt > 1 then
    begin
      dgtCnt := dgtCnt SHR 1-1;
      i := dgtcnt;
      repeat
        UD_half[i-dgtcnt] := n mod 9+1;
        n := n div 9;
        dec(dgtCnt);
      until dgtCnt <0;
    end;
  end;
end;

procedure NextNumb(var UD:tUpDown);
var
  i,dc,dgt : Uint32;
begin
  with UD do
  begin
    dc:= UD_Dgt;
    if dc>1 then
    Begin
      i := 0;
      dc := dc shr 1-1;
      repeat
        dgt := UD_half[i]+1;
      if dgt <10 then
      begin
        UD_half[i] := dgt;
        BREAK;
      end;
      UD_half[i] := 1;
      inc(i);
    until  i > dc;

    if i > dc then
    Begin
      UD_half[i]:= 1;
      inc(UD_Dgt);
    end;
  end
  else
  begin
    inc(UD_Dgt);
    UD_half[0] := 1;
  end;
  end;
end;

var
{$ALIGN 32}
  UD1,Ud2 : tUpDown;
  Count,
  limit : UInt64;
Begin
  Count := 0;
  limit := 50;
  Writeln('First fifty upside-downs:');
  limit := 50;
  repeat
    NextNumb(UD1);
    inc(Count);
    write(EmitUpDownNumber(UD1):5);
    if Count MOD 10 = 0 then
       writeln;
  until Count>=limit;

  writeln;
  writeln('      digits  count               value');
  repeat
    repeat
      NextNumb(UD1);inc(Count);
    until count >= limit;
    NthUpDownNumber(count,UD2);
    writeln(' next ',UD1.UD_Dgt:3,count:10,EmitUpDownNumber(UD1):20);
    writeln(' calc ',UD2.UD_Dgt:3,count:10,EmitUpDownNumber(UD2):20);
    limit *= 10;
  until Limit > 50*1000*1000 ;
  writeln;

  limit :=TotalCnt_Dgt[High(TotalCnt_Dgt)-1]-1;
  NthUpDownNumber(Limit,UD2);
  writeln(limit:20,UD2.UD_Dgt:6,EmitUpDownNumber(UD2):20*2+2);
  inc(limit);
  writeln('+1':20);
  NthUpDownNumber(Limit,UD2);
  writeln(limit:20,UD2.UD_Dgt:6,EmitUpDownNumber(UD2):20*2+2,#13);
  writeln('Highest nth High(Uint64)-1');
  limit := TotalCnt_Dgt[High(TotalCnt_Dgt)]-1;
  NthUpDownNumber(Limit,UD2);
  writeln(limit:20,UD2.UD_Dgt:6,EmitUpDownNumber(UD2):20*2+2,#13);
end.
