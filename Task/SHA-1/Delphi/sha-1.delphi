program Sha_1;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DCPsha1;

function SHA1(const Str: string): string;
var
  HashDigest: array of byte;
  d: Byte;
begin
  Result := '';
  with TDCP_sha1.Create(nil) do
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
  Writeln(SHA1('Rosetta Code'));
  readln;
end.
