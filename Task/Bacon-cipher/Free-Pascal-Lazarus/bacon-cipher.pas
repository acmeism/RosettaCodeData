program BaconCipher;

type
  TCode = string[5];
  TLetterCodes = array['a' .. 'z'] of TCode;

const
  LetterCodes: TLetterCodes = (
    'AAAAA', 'AAAAB', 'AAABA', 'AAABB', 'AABAA',
    'AABAB', 'AABBA', 'AABBB', 'ABAAA', 'ABAAB',
    'ABABA', 'ABABB', 'ABBAA', 'ABBAB', 'ABBBA',
    'ABBBB', 'BAAAA', 'BAAAB', 'BAABA', 'BAABB',
    'BABAA', 'BABAB', 'BABBA', 'BABBB', 'BBAAA',
    'BBAAB');
  SpaceCode = 'BBBAA';

  function GetCode(C: char): TCode;
  begin
    if (C >= 'a') and (C <= 'z') then
      Result := LetterCodes[C]
    else
      Result := SpaceCode;
  end;

  function GetChar(Code: TCode): char;
  var
    C: char;
  begin
    if SpaceCode = Code then
      Result := ' '
    else
    begin
      for C := 'a' to 'z' do
        if LetterCodes[C] = Code then
        begin
          Result := C;
          Exit;
        end;
      WriteLn;
      WriteLn('Code ''', Code, ''' is invalid');
      Halt;
    end;
  end;

  function BaconEncode(PlainText, Message: string): string;
  var
    I, Count, ELen, MLen: cardinal;
    C: char;
    ET: string;
  begin
    ELen := 5 * Length(PlainText);
    MLen := Length(Message);
    LowerCase(PlainText);
    ET := '';
    for I := 1 to Length(PlainText) do
      ET := Concat(ET, GetCode(PlainText[I]));

    { 'A's to be in lower case, 'B's in upper case }
    LowerCase(Message);
    Result := Message;
    Count := 1;
    I := 1;
    while I <= MLen do
    begin
      C := Message[I];
      if (C >= 'a') and (C <= 'z') then
      begin
        if ET[Count] = 'A' then
          Result[I] := C
        else
          Result[I] := UpCase(C);
        Inc(Count);
        if Count > ELen then
          Break;
      end
      else
        Result[I] := C;
      Inc(I);
    end;
    Result := Copy(Result, 1, I);
  end;

  function BaconDecode(CipherText: string): string;
  var
    I, IP, Count, PLen: cardinal;
    C: char;
    CT: string;
  begin
    Count := 1;
    CT := CipherText;
    for I := 1 to Length(CipherText) do
    begin
      C := CipherText[I];
      if (C >= 'a') and (C <= 'z') then
      begin
        CT[Count] := 'A';
        Inc(Count);
      end
      else if (C >= 'A') and (C <= 'Z') then
      begin
        CT[Count] := 'B';
        Inc(Count);
      end;
    end;
    CT := Copy(CT, 1, Count);
    PLen := Length(CT) div 5;
    IP := 1;
    for I := 1 to PLen do
    begin
      Result[I] := GetChar(Copy(CT, IP, 5));
      Inc(IP, 5);
    end;
    Result := Copy(Result, 1, PLen);
  end;

var
  PlainText, HiddenText: string;
  Message, CipherText: string;
begin
  PlainText := 'the quick brown fox jumps over the lazy dog';
  Message := 'bacon''s cipher is a method of steganography created by ' +
    'francis bacon. this task is to implement a program for encryption and ' +
    'decryption of plaintext using the simple alphabet of the baconian ' +
    'cipher or some other kind of representation of this alphabet (make ' +
    'anything signify anything). the baconian alphabet may optionally be ' +
    'extended to encode all lower case characters individually and/or ' +
    'adding a few punctuation characters such as the space.';
  CipherText := BaconEncode(PlainText, Message);
  WriteLn('Cipher text:');
  WriteLn(CipherText);
  HiddenText := BaconDecode(CipherText);
  WriteLn;
  WriteLn('Hidden text:');
  WriteLn(HiddenText);
  {ReadLn;}
end.
