program Fairshare;
{$IFDEF FPC}{$MODE Delphi}{$Optimization ON,ALL}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
const
  maxDigitCnt = 32;
type
  tdigit  = Uint32;
  tDgtSum = record
              dgts   : array[0..maxDigitCnt-1] of tdigit;
              dgtNum : Uint64;
              dgtsum : Uint64;//maxValue maxDigitCnt*(dgtBase-1)
              dgtBase,
              dgtThue : tDigit;
            end;
procedure OutDgtSum(const ds:tDgtSum);
var
  i : NativeInt;
Begin
  with ds do
  Begin
    writeln(' base ',dgtBase,' sum of digits :  ',dgtSum,' dec number ',dgtNum);
    i := Low(dgts);
    repeat
      write(dgts[i],'|');
      inc(i);
    until i > High(dgts);
    writeln;
  end;
end;

function IncDgtSum(var ds:tDgtSum):boolean;
//add 1 to dgts and corrects sum of Digits
//return false if overflow happens
var
  i,base_1 : NativeInt;
Begin
  with ds do
  begin
    i := High(dgts);
    base_1 := dgtBase-1;
    inc(dgtNum);
    repeat
      IF dgts[i] < base_1 then
      //add one and done
      Begin
        inc(dgts[i]);
        inc(dgtSum);
        BREAK;
      end
      else
      Begin
        dgts[i] := 0;
        dec(dgtSum,base_1);
      end;
      dec(i);
    until i < Low(dgts);
    dgtThue := dgtSum MOD (base_1+1);
    result := i < Low(dgts)
  end;
end;

procedure CheckBase_N_Turns( base:tDigit;turns:NativeUInt);
var
  actualNo :tDgtSum;
  slots : array of Uint32;
  pSlots : pUint32;
  i : NativeUInt;
Begin
  fillchar(actualNo,SizeOf(actualNo),#0);
  setlength(slots,base);
  pSlots := @slots[0];
  actualNo.dgtBase := Base;
  Write(base:3,' [');
  while turns>0 do
  Begin
    inc(pSlots[actualNo.dgtThue],turns);
    IncDgtSum(actualNo);
    dec(turns);
  end;
  For i := 0 to Base-1 do
    write(pSlots[i],' ');
  writeln(']');
end;

procedure SumBase_N_Turns( base:tDigit;turns:NativeUInt);
var
  actualNo :tDgtSum;
Begin
  fillchar(actualNo,SizeOf(actualNo),#0);
  actualNo.dgtBase := Base;
  Write(base:3,' [');
  while turns>1 do
  Begin
    write(actualNo.dgtThue,',');
    IncDgtSum(actualNo);
    dec(turns);
  end;
  writeln(actualNo.dgtThue,']');
end;

var
  turns : NativeInt;
Begin
  turns := 25;
  SumBase_N_Turns(2,turns);  SumBase_N_Turns(3,turns);
  SumBase_N_Turns(5,turns);  SumBase_N_Turns(11,turns);

  Writeln;
  writeln('Summing up descending numbers from turns downto 0');;
  turns := 2*3*5*11;
  Writeln(turns,' turns = 2*3*5*11');
  CheckBase_N_Turns(2,turns); CheckBase_N_Turns(3,turns);
  CheckBase_N_Turns(5,turns); CheckBase_N_Turns(11,turns);

  turns := sqr(2)*sqr(3)*sqr(5)*sqr(11);
  Writeln(turns,' turns = sqr(2)*sqr(3)*sqr(5)*sqr(11)');
  CheckBase_N_Turns(2,turns); CheckBase_N_Turns(3,turns);
  CheckBase_N_Turns(5,turns); CheckBase_N_Turns(11,turns);
end.
