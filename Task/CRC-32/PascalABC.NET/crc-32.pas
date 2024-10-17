type
  TCrc32 = array[0..255] of longword;

function CreateCrcTable(): TCrc32;
begin
  for var i: longword := 0 to 255 do
  begin
    var rem := i;
    for var j := 0 to 7 do
      if (rem and 1) > 0 then rem := (rem shr 1) xor $edb88320
      else rem := rem shr 1;
    result[i] := rem
  end;
end;

const
  Crc32Table = CreateCrcTable;

function Crc32(s: string): longword;
begin
  result := $ffffffff;
  foreach var c in s do
    result := (result shr 8) xor Crc32Table[(result and $ff) xor byte(c)];
  result := not result
end;

begin
  writeln('crc32 = ', crc32('The quick brown fox jumps over the lazy dog').ToString('X'));
end.
