program SHA256_Merkle_tree;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  DCPsha256;

function SHA256(const Input: TArray<Byte>; Len: Integer = -1): TArray<Byte>;
var
  Hasher: TDCP_sha256;
  l: Integer;
begin
  if Len < 0 then
    l := length(Input)
  else
    l := Len;

  Hasher := TDCP_sha256.Create(nil);
  try
    Hasher.Init;
    Hasher.Update(Input[0], l);
    SetLength(Result, Hasher.HashSize div 8);
    Hasher.final(Result[0]);
  finally
    Hasher.Free;
  end;
end;

function Merkle_tree(FileName: TFileName): string;
const
  blockSize = 1024;
var
  f: TMemoryStream;
  hashes: TArray<TArray<byte>>;
  bytesRead: Cardinal;
  buffer: TArray<byte>;
  i, index: Integer;
begin
  Result := '';
  if not FileExists(FileName) then
    exit;

  SetLength(buffer, blockSize);
  FillChar(buffer[0], blockSize, 0);
  f := TMemoryStream.Create;
  f.LoadFromFile(FileName);
  index := 0;
  repeat
    bytesRead := f.Read(buffer, blockSize);
    if 0 = bytesRead then
      Break;

    Insert(SHA256(buffer, bytesRead), hashes, index);
    inc(index);
  until false;
  f.Free;

  SetLength(buffer, 64);

  while Length(hashes) > 1 do
  begin
    var hashes2: TArray<TArray<byte>>;
    index := 0;
    i := 0;
    while i < length(hashes) do
    begin
      if i < length(hashes) - 1 then
      begin
        buffer := copy(hashes[i], 0, length(hashes[i]));
        buffer := concat(buffer, copy(hashes[i + 1], 0, length(hashes[i])));
        Insert(SHA256(buffer), hashes2, index);
        inc(index);
      end
      else
      begin
        Insert(hashes[i], hashes2, index);
        inc(index);
      end;
      inc(i, 2);
    end;
    hashes := hashes2;
  end;

  Result := '';
  for var b in hashes[0] do
  begin
    Result := Result + b.ToHexString(2);
  end;
end;

begin
  writeln(Merkle_tree('title.png'));
  readln;
end.
