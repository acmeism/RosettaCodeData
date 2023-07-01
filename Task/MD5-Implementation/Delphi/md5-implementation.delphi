program MD5Implementation;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

type
  TTestCase = record
    hashCode: string;
    _: string;
  end;

var
  testCases: array[0..6] of TTestCase = ((
    hashCode: 'D41D8CD98F00B204E9800998ECF8427E';
    _: ''
  ), (
    hashCode: '0CC175B9C0F1B6A831C399E269772661';
    _: 'a'
  ), (
    hashCode: '900150983CD24FB0D6963F7D28E17F72';
    _: 'abc'
  ), (
    hashCode: 'F96B697D7CB7938D525A2F31AAF161D0';
    _: 'message digest'
  ), (
    hashCode: 'C3FCD3D76192E4007DFB496CCA67E13B';
    _: 'abcdefghijklmnopqrstuvwxyz'
  ), (
    hashCode: 'D174AB98D277D9F5A5611C2C9F419D9F';
    _: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  ), (
    hashCode: '57EDF4A22BE3C955AC49DA2E2107B67A';
    _: '12345678901234567890123456789' + '012345678901234567890123456789012345678901234567890'
  ));
  shift: array of UInt32 = [7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21];
  table: array[0..63] of UInt32;

procedure Init();
var
  i: integer;

  function fAbs(x: Extended): Extended;
  begin
    if x < 0 then
      exit(-x);
    exit(x);
  end;

begin
  for i := 0 to High(table) do
    table[i] := Trunc((UInt64(1) shl 32) * fAbs(Sin(i + 1.0)));
end;

function Md5(s: string): TBytes;
const
  BUFFER_SIZE = 16;
var
  binary: TBytesStream;
  buffer: Tarray<UInt32>;
  messageLenBits: UInt64;
  i, j, bufferIndex, count: integer;
  byte_data: byte;
  string_data: ansistring;
  k, k1: Tarray<UInt32>;
  f, rnd, sa: UInt32;
  tmp: UInt64;
begin
  k := [$67452301, $EFCDAB89, $98BADCFE, $10325476];

  binary := TBytesStream.Create();

  if not s.IsEmpty then
  begin
    string_data := Utf8ToAnsi(s);
    binary.Write(Tbytes(string_data), length(string_data));
  end;

  byte_data := $80;
  binary.Write(byte_data, 1);

  messageLenBits := UInt64(s.Length * 8);
  count := s.Length + 1;

  while (count mod 64) <> 56 do
  begin
    byte_data := $00;
    binary.Write(byte_data, 1);
    inc(count);
  end;

  binary.Write(messageLenBits, sizeof(messageLenBits));

  SetLength(buffer, BUFFER_SIZE);
  SetLength(k1, length(k));

  binary.Seek(0, soFromBeginning);

  while binary.Read(buffer[0], BUFFER_SIZE * 4) > 0 do
  begin
    for i := 0 to 3 do
      k1[i] := k[i];

    for i := 0 to 63 do
    begin
      f := 0;
      bufferIndex := i;
      rnd := i shr 4;
      case rnd of
        0:
          f := (k1[1] and k1[2]) or (not k1[1] and k1[3]);
        1:
          begin
            f := (k1[1] and k1[3]) or (k1[2] and not k1[3]);
            bufferIndex := (bufferIndex * 5 + 1) and $0F
          end;
        2:
          begin
            f := k1[1] xor k1[2] xor k1[3];
            bufferIndex := (bufferIndex * 3 + 5) and $0F;
          end;
        3:
          begin
            f := k1[2] xor (k1[1] or not k1[3]);
            bufferIndex := (bufferIndex * 7) and $0F;
          end;
      end;

      sa := shift[(rnd shl 2) or (i and 3)];

      k1[0] := k1[0] + f + buffer[bufferIndex] + table[i];

      tmp := k1[0];

      k1[0] := k1[3];
      k1[3] := k1[2];
      k1[2] := k1[1];

      k1[1] := ((tmp shl sa) or (tmp shr (32 - sa))) + k1[1];
    end;

    for i := 0 to 3 do
      k[i] := k[i] + k1[i];
  end;

  SetLength(result, BUFFER_SIZE);

  binary.Clear;
  for i := 0 to 3 do
    binary.Write(k[i], 4);

  binary.Seek(0, soBeginning);

  binary.Read(Result, BUFFER_SIZE);

  binary.Free;
end;

function BytesToString(b: TBytes): string;
var
  v: byte;
begin
  Result := '';
  for v in b do
    Result := Result + v.ToHexString(2);
end;

var
  tc: TTestCase;

begin
  Init;

  for tc in testCases do
    Writeln(Format('%s'#10'%s'#10, [tc.hashCode, BytesToString(md5(tc._))]));
  Readln;
end.
