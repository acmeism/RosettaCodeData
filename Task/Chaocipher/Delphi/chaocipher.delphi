program Chaocipher;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TMode = (mcEncrypt, mcDecrypt);

const
  lAlphabet = 'HXUCZVAMDSLKPEFJRIGTWOBNYQ';
  rAlphabet = 'PTLNBQDEOYSFAVZKGJRIHWXUMC';

function Chao(text: AnsiString; Mode: TMode; showSteps: boolean): AnsiString;
begin
  var len := Length(text);

  var left: AnsiString := lAlphabet;
  var right: AnsiString := rAlphabet;

  var eText: AnsiString;
  SetLength(eText, len);
  var temp: AnsiString;
  SetLength(temp, 26);

  for var i := 0 to len - 1 do
  begin
    if showSteps then
      writeln(left, ' ', right);

    var index := 0;

    if Mode = mcEncrypt then
    begin
      index := pos(text[i + 1], right) - 1;
      eText[i + 1] := left[index + 1];
    end
    else
    begin
      index := pos(text[i + 1], left) - 1;
      eText[i + 1] := right[index + 1];
    end;

    if i = len - 1 then
      Break;

    // premute left
    for var j := index to 25 do
      temp[j - index + 1] := left[j + 1];

    for var j := 0 to index - 1 do
      temp[27 - index + j] := left[j + 1];
    var store := temp[2];

    for var j := 2 to 13 do
      temp[j] := temp[j + 1];

    temp[14] := store;

    left := temp;

    // permute right
    for var j := index to 25 do
      temp[j - index + 1] := right[j + 1];

    for var j := 0 to index - 1 do
      temp[27 - index + j] := right[j + 1];

    store := temp[0 + 1];

    for var j := 1 to 25 do
      temp[j] := temp[j + 1];

    temp[26] := store;
    store := temp[3];

    for var j := 3 to 13 do
      temp[j] := temp[j + 1];

    temp[14] := store;

    right := temp;
  end;
  Result := eText;
end;

begin
  var plainText := 'WELLDONEISBETTERTHANWELLSAID';
  writeln('The original plaintext is :', plainText);
  write(#10'The left and right alphabets after each permutation ');
  writeln('during encryption are :'#10);
  var cipherText := Chao(plainText, mcEncrypt, true);
  writeln(#10'The ciphertext is :', cipherText);
  var plainText2 := Chao(cipherText, mcDecrypt, false);
  writeln(#10'The recovered plaintext is : ', plainText2);
  readln;
end.
