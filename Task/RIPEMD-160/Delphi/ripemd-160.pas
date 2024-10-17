program RIPEMD160;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DCPripemd160;

function HashRipemd160(const Input: Ansistring): TArray<byte>;
var
  Hasher: TDCP_ripemd160;
begin
  Hasher := TDCP_ripemd160.Create(nil);
  try
    Hasher.Init;
    Hasher.UpdateStr(Input);
    SetLength(Result, Hasher.HashSize div 8);
    Hasher.final(Result[0]);
  finally
    Hasher.Free;
  end;
end;

begin
  for var b in HashRipemd160('Rosetta Code') do
  begin
    write(b.ToHexString(2));
  end;
  readln;
end.
