program Public_point_to_address;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Winapi.Windows,
  DCPsha256,
  DCPripemd160;

const
  bitcoinVersion = 0;

type
  TByteArray = array of Byte;

  TA25 = TByteArray;

  TPPoint = record
    x, y: TByteArray;
    constructor SetHex(xi, yi: ansistring);
  end;

  TA25Helper = record helper for TA25
  public
    constructor Create(p: TPPoint);
    function DoubleSHA256(): TByteArray;
    procedure UpdateChecksum();
    procedure SetPoint(p: TPPoint);
    function ToBase58: Ansistring;
  end;

function HashSHA256(const Input: TByteArray): TByteArray;
var
  Hasher: TDCP_sha256;
begin
  Hasher := TDCP_sha256.Create(nil);
  try
    Hasher.Init;
    Hasher.Update(Input[0], Length(Input));
    SetLength(Result, Hasher.HashSize div 8);
    Hasher.final(Result[0]);
  finally
    Hasher.Free;
  end;
end;

function HashRipemd160(const Input: TByteArray): TByteArray;
var
  Hasher: TDCP_ripemd160;
begin
  Hasher := TDCP_ripemd160.Create(nil);
  try
    Hasher.Init;
    Hasher.Update(Input[0], Length(Input));
    SetLength(Result, Hasher.HashSize div 8);
    Hasher.final(Result[0]);
  finally
    Hasher.Free;
  end;
end;

{ TPPoint }

constructor TPPoint.SetHex(xi, yi: ansistring);

  function StrToHexArray(value: Ansistring): TByteArray;
  var
    b: ansistring;
    h, i: integer;
  begin
    SetLength(Result, 32);

    for i := 0 to 31 do
    begin
      b := '$' + copy(value, i * 2 + 1, 2);
      if not TryStrToInt(b, h) then
        raise Exception.CreateFmt('Error in TPPoint.SetHex.StrToHexArray: Invalid hex string in position %d of "x"',
          [i * 2]);
      Result[i] := h;
    end;
  end;

begin
  if (Length(xi) <> 64) or (Length(yi) <> 64) then
    raise Exception.Create('Error in TPPoint.SetHex: Invalid hex string length');

  x := StrToHexArray(xi);
  y := StrToHexArray(yi);
end;

{ TA25Helper }

constructor TA25Helper.Create(p: TPPoint);
begin
  SetLength(self, 25);
  SetPoint(p);
end;

function TA25Helper.DoubleSHA256: TByteArray;
begin
  Result := HashSHA256(HashSHA256(copy(self, 0, 21)));
end;

procedure TA25Helper.SetPoint(p: TPPoint);
var
  c, s: TByteArray;
begin
  c := concat([4], p.x, p.y);
  s := HashSHA256(c);

  self := concat([self[0]], HashRipemd160(s));
  SetLength(self, 25);
  UpdateChecksum;
end;

function TA25Helper.ToBase58: Ansistring;
var
  c, i, n: Integer;
const
  Size = 34;
  Alphabet: Ansistring = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
begin
  SetLength(Result, Size);
  for n := Size - 1 downto 0 do
  begin
    c := 0;
    for i := 0 to 24 do
    begin
      c := c * 256 + Self[i];
      Self[i] := byte(c div 58);
      c := c mod 58;
    end;
    Result[n + 1] := Alphabet[c + 1];
  end;

  i := 2;
  while (i < Size) and (result[i] = '1') do
    inc(i);

  Result := copy(Result, i - 1, Size);
end;

procedure TA25Helper.UpdateChecksum;
begin
  CopyMemory(@self[21], @self.DoubleSHA256[0], 4);
end;

var
  p: TPPoint;
  a: TA25;

const
  x: Ansistring = '50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352';
  y: Ansistring = '2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6';

begin
  p.SetHex(x, y);

  a := TA25.Create(p);
  writeln(a.ToBase58);
  readln;
end.
