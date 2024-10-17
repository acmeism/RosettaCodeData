uses School;

function GrayEncode(n: longword): longword := n xor (n shr 1);

function GrayDecode(n: longword): longword;
begin
  Result := 0;
  while n > 0 do
  begin
    Result := Result xor n;
    n := n shr 1;
  end;
end;

begin
  for var i := 0 to 31 do
    Writeln($'{i,-7} {Bin(i),-7} {Bin(grayEncode(i)),-7} {grayDecode(grayEncode(i)),-7}');
end.
