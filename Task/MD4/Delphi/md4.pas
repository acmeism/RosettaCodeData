program CalcMD4;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DCPmd4;

function MD4(const Str: string): string;
var
  HashDigest: array of byte;
  d: Byte;
begin
  Result := '';
  with TDCP_md4.Create(nil) do
  begin
    Init;
    UpdateStr(Str);
    SetLength(HashDigest, GetHashSize div 8);
    final(HashDigest[0]);
    for d in HashDigest do
      Result := Result + d.ToHexString(2);
    Free;
  end;
end;

begin
  Writeln(MD4('Rosetta Code'));
  readln;
end.
