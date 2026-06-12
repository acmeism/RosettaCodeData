program primewords;

uses
  Classes,SysUtils;

const
  C_FNAME = 'unixdict.txt';
  PRIMES: set of 0..255 = [67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113];

  function IsPrimeWord(const S: string): boolean;
  var
    Ch: char;
  begin
    for Ch in S do
      if not (Ord(Ch) in PRIMES) then
        Exit(False);
    Result := True;
  end;

var
  UnixDict: TStringList;
  Line: string;

begin
  UnixDict := TStringList.Create;
  try
    UnixDict.LoadFromFile(C_FNAME);
    for Line in UnixDict do
      if IsPrimeWord(Line) then
        Writeln(Line);
  except
    on E: EInOutError do
      Writeln('File handling error occurred. Reason: ', E.Message);
  end;
  UnixDict.Free;
end.
