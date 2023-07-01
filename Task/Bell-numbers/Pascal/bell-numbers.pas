program BellNumbers;
{$Ifdef FPC}
  {$optimization on,all}
{$ElseIf}
  {Apptype console}
{$EndIf}
uses
  sysutils,gmp;
var
  T0 :TDateTime;
procedure BellNumbersUint64(OnlyBellNumbers:Boolean);
var
  BList : array[0..24] of Uint64;
  BellNum : Uint64;
  BListLenght,i :nativeUInt;
begin
  IF OnlyBellNUmbers then
  Begin
    writeln('Bell triangles ');
    writeln('  1 = 1');
  end
  else
  Begin
    writeln('Bell numbers');
    writeln('  1 = 1');
    writeln('  2 = 1');
  end;

  BList[0]:= 1;
  BListLenght := 1;
  BellNum := 1;
  repeat
//  For i := BListLenght downto 1 do BList[i] := BList[i-1]; or
    move(Blist[0],Blist[1],BListLenght*SizeOf(Blist[0]));
    BList[0] := BellNum;
    For i := 1 to BListLenght do
    Begin
      BellNum += BList[i];
      BList[i] := BellNum;
    end;

//  Output
    IF OnlyBellNUmbers then
    Begin
      IF BListLenght<=9 then
      Begin
        write(BListLenght+1:3,' = ');
        For i := 0 to BListLenght do
          write(BList[i]:7);
        writeln;
      end
      ELSE
        BREAK;
    end
    else
      writeln(BListLenght+2:3,' = ',BellNum);

    inc(BListLenght);
  until  BListLenght >= 25;
  writeln;
end;

procedure BellNumbersMPInteger;
const
  MaxIndex = 5000;//must be > 0
var
//MPInteger as alternative to mpz_t -> selfcleaning
  BList : array[0..MaxIndex] of MPInteger;
  BellNum : MPInteger;
  BListLenght,i :nativeUInt;
  BellNumStr : AnsiString;
Begin
  BellNumStr := '';
  z_init(BellNum);
  z_ui_pow_ui(BellNum,10,32767);
  BListLenght := z_size(BellNum);
  writeln('init length ',BListLenght);
  For i := 0 to MaxIndex do
  Begin
//    z_init2_set(BList[i],BListLenght);
    z_add_ui( BList[i],i);
  end;
  writeln('init length ',z_size(BList[0]));

  T0 := now;
  BListLenght := 1;
  z_set_ui(BList[0],1);
  z_set_ui(BellNum,1);
  repeat
    //Move does not fit moving interfaces //    call    fpc_intf_assign
    For i := BListLenght downto 1 do  BList[i] := BList[i-1];
    z_set(BList[0],BellNum);
    For i := 1 to BListLenght do
    Begin
      BellNum := z_add(BellNum,BList[i]);
      z_set(BList[i],BellNum);
    end;
    inc(BListLenght);
    if (BListLenght+1) MOD 100 = 0 then
    Begin
      BellNumStr:= z_get_str(10,BellNum);
      //z_sizeinbase (BellNum, 10) is not exact :-(
      write('Bell(',(IntToStr(BListLenght)):6,') has ',
           (IntToStr(Length(BellNumStr))):6,' decimal digits');
      writeln(FormatDateTime(' NN:SS.ZZZ',now-T0),'s');
    end;
  until  BListLenght>=MaxIndex;
  BellNumStr:= z_get_str(10,BellNum);
  writeln(BListLenght:6,'.th ',Length(BellNumStr):8);

//clean up ;-)
  BellNumStr := '';
  z_clear(BellNum);
  For i := MaxIndex downto 0 do
    z_clear(BList[i]);
end;

BEGIN
  BellNumbersUint64(True);BellNumbersUint64(False);
  BellNumbersMPInteger;
END.
