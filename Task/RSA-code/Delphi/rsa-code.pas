program RSA_code;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers;

type
  TRSA = record
  private
    n, e, d: BigInteger;
    class function PlainTextAsNumber(data: AnsiString): BigInteger; static;
    class function NumberAsPlainText(Num: BigInteger): AnsiString; static;
  public
    constructor Create(n, e, d: string);
    function Encode(data: AnsiString): string;
    function Decode(code: string): AnsiString;
  end;

function EncodeRSA(data: AnsiString): string;
var
  n, e, d, bb, ptn, etn, dtn: BigInteger;
begin
    // a key set big enough to hold 16 bytes of plain text in
    // a single block (to simplify the example) and also big enough
    // to demonstrate efficiency of modular exponentiation.
  n := '9516311845790656153499716760847001433441357';
  e := '65537';
  d := '5617843187844953170308463622230283376298685';

  for var c in data do
  begin
    bb := ord(c);
    ptn := (ptn shl 8) or bb;
  end;

  if BigInteger.Compare(ptn, n) >= 0 then
  begin
    Writeln('Plain text message too long');
    exit;
  end;
  writeln('Plain text as a number:', ptn.ToString);
  writeln(ptn.ToString);

  // encode a single number
  etn := BigInteger.ModPow(ptn, e, n);
  Writeln('Encoded:               ', etn.ToString);

  // decode a single number
  dtn := BigInteger.ModPow(etn, d, n);
  Writeln('Decoded:               ', dtn.ToString);

  // convert number to text
  var db: AnsiString;
  var bff: BigInteger := $FF;
  while dtn.BitLength > 0 do
  begin
    db := ansichar((dtn and bff).AsInteger) + db;
    dtn := dtn shr 8;
  end;
  Write('Decoded number as text:"', db, '"');
end;

const
  pt = 'Rosetta Code';

{ TRSA }

constructor TRSA.Create(n, e, d: string);
begin
  self.n := n;
  self.e := e;
  self.d := d;
end;

function TRSA.Decode(code: string): AnsiString;
var
  etn, dtn: BigInteger;
begin
   // decode a single number
  etn := code;
  dtn := BigInteger.ModPow(etn, d, n);
  Result := NumberAsPlainText(dtn);
end;

function TRSA.Encode(data: AnsiString): string;
var
  ptn: BigInteger;
begin
  ptn := PlainTextAsNumber(data);

  // encode a single number
  Result := BigInteger.ModPow(ptn, e, n).ToString;
end;

class function TRSA.NumberAsPlainText(Num: BigInteger): AnsiString;
var
  bff: BigInteger;
begin
  // convert number to text
  bff := $FF;
  Result := '';
  while Num.BitLength > 0 do
  begin
    Result := ansichar((Num and bff).AsInteger) + Result;
    Num := Num shr 8;
  end;
end;

class function TRSA.PlainTextAsNumber(data: AnsiString): BigInteger;
var
  c: AnsiChar;
  bb, n: BigInteger;
begin
  Result := 0;
  n := '9516311845790656153499716760847001433441357';
  for c in data do
  begin
    bb := ord(c);
    Result := (Result shl 8) or bb;
  end;

  if BigInteger.Compare(Result, n) >= 0 then
    raise Exception.Create('Plain text message too long');
end;

var
  RSA: TRSA;
  Encoded: string;

const
  n = '9516311845790656153499716760847001433441357';
  e = '65537';
  d = '5617843187844953170308463622230283376298685';
  TEST_WORD = 'Rosetta Code';

begin
  RSA := TRSA.Create(n, e, d);
  Encoded := RSA.Encode(TEST_WORD);
  writeln('Plain text:            ', TEST_WORD);
  writeln('Encoded:               ', Encoded);
  writeln('Decoded:               ', RSA.Decode(Encoded));
  Readln;
end.
