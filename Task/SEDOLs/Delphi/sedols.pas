program Sedol;

{$APPTYPE CONSOLE}

uses
  SysUtils;


const
  SEDOL_CHR_COUNT = 6;
  DIGITS = ['0'..'9'];
  LETTERS = ['A'..'Z'];
  VOWELS = ['A', 'E', 'I', 'O', 'U'];
  ACCEPTABLE_CHRS = DIGITS + LETTERS - VOWELS;
  WEIGHTS : ARRAY [1..SEDOL_CHR_COUNT] of integer = (1, 3, 1, 7, 3, 9);
  LETTER_OFFSET = 9;


function AddSedolCheckDigit(Sedol : string) : string;
var
  iChr : integer;
  Checksum : integer;
  CheckDigit : char;
begin
  if Sedol <> uppercase(Sedol) then
    raise ERangeError.CreateFmt('%s contains lower case characters',[Sedol]);
  if length(Sedol) <> SEDOL_CHR_COUNT then
    raise ERangeError.CreateFmt('"%s" length is invalid. Should be 6 characters',[Sedol]);

  Checksum := 0;
  for iChr := 1 to SEDOL_CHR_COUNT do
  begin

    if Sedol[iChr] in Vowels then
      raise ERangeError.CreateFmt('%s contains a vowel (%s) at chr %d',[Sedol, Sedol[iChr], iChr]);
    if not (Sedol[iChr] in ACCEPTABLE_CHRS) then
      raise ERangeError.CreateFmt('%s contains an invalid chr (%s) at position %d',[Sedol, Sedol[iChr], iChr]);

    if Sedol[iChr] in DIGITS then
      Checksum := Checksum + (ord(Sedol[iChr]) - ord('0')) * WEIGHTS[iChr]
    else
      Checksum := Checksum + (ord(Sedol[iChr]) - ord('A') + 1 + LETTER_OFFSET) * WEIGHTS[iChr];

  end;

  Checksum := (Checksum mod 10);
  if Checksum <> 0 then
    Checksum := 10 - Checksum;
  CheckDigit := chr(CheckSum + ord('0'));

  Result := Sedol + CheckDigit;
end;


procedure Test(First6 : string);
begin
  writeln(First6, ' becomes ', AddSedolCheckDigit(First6));
end;


begin
  try
    Test('710889');
    Test('B0YBKJ');
    Test('406566');
    Test('B0YBLH');
    Test('228276');
    Test('B0YBKL');
    Test('557910');
    Test('B0YBKR');
    Test('585284');
    Test('B0YBKT');
    Test('B00030');
  except
    on E : Exception do
      writeln(E.Message);
  end;
  readln;
end.
