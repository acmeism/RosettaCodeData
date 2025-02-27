const
  INT_BITS = 32;

function rotateLeft(n, d: longword) := (n shl d) or (n shr (INT_BITS - d));

function rotateRight(n, d: longword) := (n shr d) or (n shl (INT_BITS - d));

function ownCalcPass(password, nonce: string): longword;
begin
  var start := true;

  foreach var c in nonce do
  begin
    if (c <> '0') and start then
    begin
      result := password.tointeger;
      start := false;
    end;
    case c of
      '0': ;
      '1': result := rotateRight(result, 7);
      '2': result := rotateRight(result, 4);
      '3': result := rotateRight(result, 3);
      '4': result := rotateLeft(result, 1);
      '5': result := rotateLeft(result, 5);
      '6': result := rotateLeft(result, 12);
      '7': result := (result and $0000FF00) or result shl 24
                     or (result and $00FF0000) shr 16 or (result and $FF000000) shr 8;
      '8': result := result shl 16 or result shr 24 or (result and $00FF0000) shr 8;
      '9': result := not result;
    else raise new Exception('non-digit in nonce.');
    end;
  end;
end;

procedure testPasswordCalc(password, nonce: string; expected: longword);
begin
  var res := ownCalcPass(password, nonce);
  print(if res = expected then 'PASS ' else 'FAIL ');
  println(password, nonce, res, expected);
end;

begin
  testPasswordCalc('12345', '603356072', 25280520);
  testPasswordCalc('12345', '410501656', 119537670);
  testPasswordCalc('12345', '630292165', 4269684735);
end.
