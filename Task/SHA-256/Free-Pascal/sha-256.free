program rosettaCodeSHA256;

uses
  SysUtils, DCPsha256;

var
  ros: String;
  sha256 : TDCP_sha256;
  digest : array[0..63] of byte;
  i: Integer;
  output: String;
begin
  ros := 'Rosetta code';

  sha256 := TDCP_sha256.Create(nil);
  sha256.init;
  sha256.UpdateStr(ros);
  sha256.Final(digest);

  output := '';

  for i := 0 to 31 do begin
    output := output + intToHex(digest[i], 2);
  end;

  writeln(lowerCase(output));

end.
