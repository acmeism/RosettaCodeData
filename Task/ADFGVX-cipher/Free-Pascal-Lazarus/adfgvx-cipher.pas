program adfgvxcipher;

uses
  SysUtils,
  Classes;

const
  ADFGVX = 'ADFGVX';
  ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  MESSAGE = 'ATTACKAT1200AM';

type
  //tPolybiusarr = array[1..6,1..6] of string;
  tPolybiusarr = array[1..6, 1..6] of char;

  procedure init_Polybius(var Polybius: tPolybiusarr);

    procedure ShuffleString(var S: string);
    var
      i, j: integer;
      c: char;
    begin
      for i := Length(S) downto 2 do
      begin
        j := Random(i) + 1;  // 1..i
        c := S[i];
        S[i] := S[j];
        S[j] := c;
      end;
    end;

  var
    ShuffledAlphabet: string;
    x, y, i: integer;
  begin
    ShuffledAlphabet := ALPHABET;
    ShuffleString(ShuffledAlphabet);
    i := 1;
    for x := 1 to 6 do
      for y := 1 to 6 do
      begin
        Polybius[x, y] := ShuffledAlphabet[i];
        Inc(i);
      end;
  end;

  procedure PrintPolybius(Polybius: tPolybiusarr);
  var
    x, y: integer;
    ch: char;
  begin
    writeln('The 6 x 6 Polybius square:');
    writeln;
    Write('  |');
    for ch in ADFGVX do
      Write(ch: 2);
    writeln;
    writeln('---------------');
    for x := 1 to 6 do
    begin
      Write(ADFGVX[x], ' |');
      for y := 1 to 6 do
      begin
        Write(Polybius[x, y]: 2);
      end;
      writeln;
    end;
  end;

  function CreateKey(size: integer): string;

    procedure FilterList(var lst: TStringList; size: integer);

      function HasRepeatedCharacters(const str: string): boolean;
      var
        seen: array[0..255] of boolean;
        i: integer;
        c: byte;
      begin
        FillChar(seen, SizeOf(seen), False);
        for i := 1 to Length(str) do
        begin
          c := Ord(str[i]);
          if seen[c] then
            Exit(True);    // repeated character found
          seen[c] := True;
        end;
        Result := False;   // no repeats
      end;

    var
      x: integer;
    begin
      for x := lst.Count - 1 downto 0 do
        if (length(lst[x]) <> size) or HasRepeatedCharacters(lst[x]) then lst.Delete(x);
    end;

  const
    FNAME = 'unixdict.txt';
  var
    list: TStringList;
  begin
    if (size < 7) or (size > 12) then
    begin
      writeln('Key should contain between 7 and 12 letters, both inclusive.');
      halt;
    end;
    list := TStringList.Create;
    list.LoadFromFile(FNAME);
    filterlist(list, size);
    Result := UpperCase(list[random(list.Count)]);
    list.Free;
  end;

  function FindCharachter(ch: char; polybius: tPolybiusarr): string;
  var
    x, y: integer;
  begin
    for x := 1 to 6 do
      for y := 1 to 6 do
        if polybius[x, y] = ch then
          exit(ADFGVX[x] + ADFGVX[y]);
  end;

  function Encrypt(plainText, key: string; Polybius: tPolybiusarr): string;
  var
    ch: char;
    str: string;
    lst: TStringList;
    x, keylength: integer;
  begin
    str := '';
    keylength := length(key);
    lst := TStringList.Create;
    for x := 1 to keylength do
      lst.Add(key[x]);
    x := 0;
    for ch in plainText do
    begin
      lst[x] := lst[x] + FindCharachter(ch, Polybius);
      Inc(x);
      if x = keylength then x := 0;
    end;
    lst.Sort;
    writeln;
    for x := 0 to keylength - 1 do
      str := str + lst[x] + ' ';
    Result := TrimRight(str);
    lst.Free;
  end;

  function Decrypt(encryptedTex, key: string; polybius: tPolybiusarr): string;
    // Note: simplified decryption logic for demonstration purposes
    // need some work for longer messages
  var
    lst, tmp: TStringList;
    ch: char;
    s, str: string;
  begin
    lst := TStringList.Create;
    tmp := TStringList.Create;
    lst.AddDelimitedtext(encryptedTex, ' ', True);
    for ch in key do
      for str in lst do
        if str[1] = ch then
        begin
          tmp.Add(str);
          break;
        end;
    Result := '';
    s := '';
    for str in tmp do
    begin
      Result := Result + polybius[pos(str[2], ADFGVX), pos(str[3], ADFGVX)];
      if length(str) > 3 then s := s + polybius[pos(str[4], ADFGVX), pos(str[5], ADFGVX)];
    end;
    Result := Result + s;
    lst.Free;
    tmp.Free;
  end;

var
  Polybius: tPolybiusarr;
  key, encryptedMessage, decryptedMessage: string;

begin
  Randomize;
  init_Polybius(Polybius);
  PrintPolybius(Polybius);
  key := createkey(Random(12 - 7 + 1) + 7); //set length of word to 7 - 12
  encryptedMessage := Encrypt(MESSAGE, key, Polybius);
  decryptedMessage := Decrypt(encryptedMessage, key, polybius);
  writeln('The key is              : ', key);
  writeln('the plain message is    : ', MESSAGE);
  writeln('the encrypted message is: ', encryptedMessage);
  writeln('the decrypted message is: ', decryptedMessage);

end.
