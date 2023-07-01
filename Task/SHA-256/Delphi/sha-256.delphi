program SHA_256;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DCPsha256;

function SHA256(const Str: string): string;
var
  HashDigest: array of byte;
  d: Byte;
begin
  Result := '';
  with TDCP_sha256.Create(nil) do
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
  Writeln(SHA256('Rosetta code'));
  readln;

end.
