program OpenWebNet_password;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function ownCalcPass(password, nonce: string): Cardinal;
begin
  var start := True;
  var num1 := 0;
  var num2 := num1;
  var i := password.ToInteger();
  var pwd := i;

  for var c in nonce do
  begin
    if c <> '0' then
    begin
      if start then
        num2 := pwd;
      start := False;
    end;

    case c of
      '1':
        begin
          num1 := (num2 and $FFFFFF80) shr 7;
          num2 := num2 shl 25;
        end;
      '2':
        begin
          num1 := (num2 and $FFFFFFF0) shr 4;
          num2 := num2 shl 28;
        end;
      '3':
        begin
          num1 := (num2 and $FFFFFFF8) shr 3;
          num2 := num2 shl 29;
        end;
      '4':
        begin
          num1 := num2 shl 1;
          num2 := num2 shr 31;
        end;
      '5':
        begin
          num1 := num2 shl 5;
          num2 := num2 shr 27;
        end;
      '6':
        begin
          num1 := num2 shl 12;
          num2 := num2 shr 20;
        end;
      '7':
        begin
          var num3 := num2 and $0000FF00;
          var num4 := ((num2 and $000000FF) shl 24) or ((num2 and $00FF0000) shr 16);
          num1 := num3 or num4;
          num2 := (num2 and $FF000000) shr 8;
        end;
      '8':
        begin
          ;
          num1 := (num2 and $0000FFFF) shl 16 or (num2 shr 24);
          num2 := (num2 and $00FF0000) shr 8;
        end;
      '9':
        begin
          num1 := not num2;
        end;
    else
      num1 := num2;
    end;

    num1 := num1 and $FFFFFFFF;
    num2 := num2 and $FFFFFFFF;
    if (c <> '0') and (c <> '9') then
      num1 := num1 or num2;
    num2 := num1;
  end;
  Result := num1;
end;

function TestPasswordCalc(Password, nonce: string; expected: Cardinal): Integer;
begin
  var res := ownCalcPass(Password, nonce);
  var m := format('%s  %s  %-10u  %-10u', [Password, nonce, res, expected]);
  if res = expected then
    writeln('PASS ' + m)
  else
    writeln('FAIL ' + m);
end;

begin
  testPasswordCalc('12345', '603356072', 25280520);
  testPasswordCalc('12345', '410501656', 119537670);
  testPasswordCalc('12345', '630292165', 4269684735);
  readln;
end.
