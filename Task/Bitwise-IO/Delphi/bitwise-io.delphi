program Bitwise_IO;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

type
  TBitReader = class
  private
    readData: Cardinal;
    startPosition: Integer;
    endPosition: Integer;
    Stream: TStream;
    procedure Align;
    function BaseStream: TStream;
    procedure EnsureData(bitCount: Integer);
    function GetInBuffer: Integer;
  public
    constructor Create(sm: TStream);
    function Read(bitCount: Integer): Integer;
    function ReadBit: Boolean;
  end;

  TBitWriter = class
  private
    data: Byte;
    dataLength: Integer;
    Stream: TStream;
    procedure Align;
    function BaseStream: TStream;
    function BitsToAligment: Integer;
  public
    constructor Create(sm: TStream);
    procedure Write(value, length: Integer);
    procedure WriteBit(value: Boolean);
  end;

function TBitReader.GetInBuffer: Integer;
begin
  result := endPosition - startPosition;
end;

function TBitReader.BaseStream: TStream;
begin
  result := stream;
end;

constructor TBitReader.Create(sm: TStream);
begin
  Stream := sm;
end;

procedure TBitReader.EnsureData(bitCount: Integer);
var
  readBits: Integer;
  b: Byte;
begin
  readBits := bitCount - GetInBuffer;
  while readBits > 0 do
  begin
    BaseStream.Read(b, 1);
    readData := readData or (b shl endPosition);
    endPosition := endPosition + 8;
    readBits := readBits - 8;
  end;
end;

function TBitReader.ReadBit: Boolean;
begin
  Exit(Read(1) > 0);
end;

function TBitReader.Read(bitCount: Integer): Integer;
begin
  EnsureData(bitCount);
  result := (readData shr startPosition) and ((1 shl bitCount) - 1);
  startPosition := startPosition + bitCount;
  if endPosition = startPosition then
  begin
    endPosition := ord(startPosition = 0);
    readData := 0;
  end
  else if (startPosition >= 8) then
  begin
    readData := readData shr startPosition;
    endPosition := endPosition - startPosition;
    startPosition := 0;
  end;
end;

procedure TBitReader.Align;
begin
  endPosition := ord(startPosition = 0);
  readData := 0;
end;

function TBitWriter.BaseStream: TStream;
begin
  Exit(stream);
end;

function TBitWriter.BitsToAligment: Integer;
begin
  Exit((32 - dataLength) mod 8);
end;

constructor TBitWriter.Create(sm: TStream);
begin
  Stream := sm;
end;

procedure TBitWriter.WriteBit(value: Boolean);
begin
  self.Write(ord(value), 1);
end;

procedure TBitWriter.Write(value, length: Integer);
var
  currentData: Cardinal;
  currentLength: Integer;
begin
  currentData := data or (value shl dataLength);
  currentLength := dataLength + length;
  while currentLength >= 8 do
  begin

    BaseStream.Write(currentData, 1);
    currentData := currentData shr 8;
    currentLength := currentLength - 8;
  end;
  data := currentData;
  dataLength := currentLength;
end;

procedure TBitWriter.Align;
begin
  if dataLength > 0 then
  begin
    BaseStream.Write(data, 1);
    data := 0;
    dataLength := 0;
  end;
end;

var
  ms: TMemoryStream;
  writer: TBitWriter;
  reader: TBitReader;

begin
  ms := TMemoryStream.create();
  writer := TBitWriter.create(ms);
  writer.WriteBit(true);
  writer.Write(5, 3);
  writer.Write($0155, 11);
  writer.Align();
  ms.Position := 0;
  reader := TBitReader.create(ms);
  writeln(reader.ReadBit());
  writeln(reader.Read(3));
  writeln(format('0x%.4x', [reader.Read(11)]));
  reader.Align();
  ms.Free;
  writer.Free;
  reader.Free;
  Readln;
end.
