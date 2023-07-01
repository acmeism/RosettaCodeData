program Parallel_Brute_Force;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Threading,
  DCPsha256;

function Sha256(W: string): string;
var
  HashDigest: array[0..31] of byte;
  d, i: Byte;
begin
  Result := '';
  with TDCP_sha256.Create(nil) do
  begin
    Init;
    UpdateStr(W);
    final(HashDigest[0]);
    for i := 0 to High(HashDigest) do
      Result := Result + lowercase(HashDigest[i].ToHexString(2));
  end;
end;

procedure Force(a: int64);
var
  password: string;
  hash: string;
  i, j, k, l: integer;
  w: string;
const
  Words: TArray<string> = ['1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad',
    '3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b',
    '74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f'];
begin
  password := '     ';
  password[1] := chr(97 + a);

  for i := 97 to 122 do
  begin
    password[2] := chr(i);
    for j := 97 to 122 do
    begin
      password[3] := chr(j);
      for k := 97 to 122 do
      begin
        password[4] := chr(k);
        for l := 97 to 122 do
        begin
          password[5] := chr(l);
          hash := Sha256(password);

          for w in Words do
          begin
            if SameText(hash, w) then
            begin
              Writeln('>>', password, ' => ', hash);
            end;
          end;
        end;
      end;
    end;
  end;
end;

var
  s: string;
begin

  TParallel.&For(0, 25, Force);

  Writeln('Enter to exit');
  readln;
end.
