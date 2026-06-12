program Names_to_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Math;

function CreateMap: TDictionary<string, Int64>;
const
  smallies: array[1..19] of string = ('one', 'two', 'three', 'four', 'five',
    'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen',
    'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen');
  tens: array[2..9] of string = ('twenty', 'thirty', 'forty', 'fifty', 'sixty',
    'seventy', 'eighty', 'ninety');
  maxies: array[1..6] of string = ('thousand', 'million', 'billion', 'trillion',
    'quadrillion', 'quintillion');
var
  i: Integer;
begin
  Result := TDictionary<string, Int64>.Create();
  for i := 1 to 19 do
    Result.Add(smallies[i], i);

  for i := 2 to 9 do
    Result.Add(tens[i], i * 10);

  for i := 1 to 6 do
    Result.Add(maxies[i], Trunc(IntPower(10, i * 3)));

  Result.Add('hundred', 100);
end;

const
  zeros = '"zero","nought","nil","none","nothing"';
  MIN_INT64 = -9223372036854775808;

var
  Names: TDictionary<string, Int64>;

function nameToNum(name: string): Int64;
var
  Text, w: string;
  IsNegative: Boolean;
  words: TArray<string>;
  size: integer;
  multiplier, lastNum, sum, num: Int64;
  i: Integer;
begin
  Text := name.trim().ToLower();
  IsNegative := Text.startsWith('minus ');
  if (IsNegative) then
    Text := Text.Substring(6);

  if (Text.startsWith('a ')) then
    Text := 'one' + Text.Substring(1);
  words := Text.split([',', '-', ' and ', ' ']);

  size := Length(words);
  if ((size = 1) and (zeros.indexOf(words[0].QuotedString('"')) > -1)) then
    exit(0);

  multiplier := 1;
  lastNum := 0;
  sum := 0;

  for i := size - 1 downto 0 do
  begin
    w := words[i];
    if w.Trim.IsEmpty then
      Continue;

    if not Names.ContainsKey(w) then
      raise EArgumentException.Create(w + ' is not a valid number');

    num := Names[w];

    if (num = lastNum) then
      raise EArgumentException.Create(name + ' is not a well formed numeric string')
    else if (num >= 1000) then
    begin
      if (lastNum >= 100) then
        raise EArgumentException.Create(name + ' is not a well formed numeric string');
      multiplier := num;
      if (i = 0) then
        sum := sum + multiplier;
    end
    else if (num >= 100) then
    begin
      multiplier := multiplier * 100;
      if (i = 0) then
        sum := sum + multiplier
    end
    else if (num >= 20) then
    begin
      if (lastNum >= 10) and (lastNum <= 90) then
        raise EArgumentException.Create(name + ' is not a well formed numeric string');
      sum := sum + num * multiplier;
    end
    else
    begin
      if (lastNum >= 1) and (lastNum <= 90) then
        raise EArgumentException.Create(name + ' is not a well formed numeric string');
      sum := sum + num * multiplier;
    end;

    lastNum := num;
  end;

  if (IsNegative and (sum = -sum)) then
    exit(MIN_INT64)
  else if (sum < 0) then
    raise EArgumentException.Create(name + ' is outside the range of a Long integer');

  if (IsNegative) then
    Result := -sum
  else
    result := sum;
end;

const
  TestCases: array[0..14] of string = ('none', 'one', 'twenty-five',
    'minus one hundred and seventeen', 'hundred and fifty-six',
    'minus two thousand two', 'nine thousand, seven hundred, one',
    'minus six hundred and twenty six thousand, eight hundred and fourteen',
    'four million, seven hundred thousand, three hundred and eighty-six',
    'fifty-one billion, two hundred and fifty-two million, seventeen thousand, one hundred eighty-four',
    'two hundred and one billion, twenty-one million, two thousand and one',
    'minus three hundred trillion, nine million, four hundred and one thousand and thirty-one',
    'seventeen quadrillion, one hundred thirty-seven',
    'a quintillion, eight trillion and five',
    'minus nine quintillion, two hundred and twenty-three quadrillion, three hundred and seventy-two trillion, thirty-six billion, eight hundred and fifty-four million, seven hundred and seventy-five thousand, eight hundred and eight');

var
  name: string;

begin
  Names := CreateMap;

  for name in TestCases do
    Writeln(nameToNum(name): 20, ' = ', name);

  Names.free;
  Readln;
end.
