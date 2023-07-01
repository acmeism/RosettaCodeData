uses
  DCPsha256;

type
  TByteArray = array of Byte;

function HashSHA256(const Input: TByteArray): TByteArray;
var
  Hasher: TDCP_sha256;
begin
  Hasher := TDCP_sha256.Create(nil);
  try
    Hasher.Init;
    Hasher.Update(Input[0], Length(Input));
    SetLength(Result, Hasher.HashSize div 8);
    Hasher.Final(Result[0]);
  finally
    Hasher.Free;
  end;
end;

function DecodeBase58(const Input: string): TByteArray;
const
  Size = 25;
  Alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
var
  C: Char;
  I, J: Integer;
begin
  SetLength(Result, Size);

  for C in Input do
  begin
    I := Pos(C, Alphabet) - 1;

    if I = -1 then
      raise Exception.CreateFmt('Invalid character found: %s', [C]);

    for J := High(Result) downto 0 do
    begin
      I := I + (58 * Result[J]);
      Result[J] := I mod 256;
      I := I div 256;
    end;

    if I <> 0 then
      raise Exception.Create('Address too long');
  end;
end;

procedure ValidateBitcoinAddress(const Address: string);
var
  Hashed: TByteArray;
  Decoded: TByteArray;
begin
  if (Length(Address) < 26) or (Length(Address) > 35) then
    raise Exception.Create('Wrong length');

  Decoded := DecodeBase58(Address);
  Hashed := HashSHA256(HashSHA256(Copy(Decoded, 0, 21)));

  if not CompareMem(@Decoded[21], @Hashed[0], 4) then
    raise Exception.Create('Bad digest');
end;
