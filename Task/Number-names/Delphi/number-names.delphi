program Number_names;

{$APPTYPE CONSOLE}

const
  smallies: array[1..19] of string = ('one', 'two', 'three', 'four', 'five',
    'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen',
    'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen');
  tens: array[2..9] of string = ('twenty', 'thirty', 'forty', 'fifty', 'sixty',
    'seventy', 'eighty', 'ninety');

function domaxies(number: int64): string;
const
  maxies: array[0..5] of string = (' thousand', ' million', ' billion',
    ' trillion', ' quadrillion', ' quintillion');
begin
  domaxies := '';
  if number >= 0 then
    domaxies := maxies[number];
end;

function doHundreds(number: int64): string;
begin
  Result := '';
  if number > 99 then
  begin
    Result := smallies[number div 100];
    Result := Result + ' hundred';
    number := number mod 100;
    if number > 0 then
      Result := Result + ' and ';
  end;
  if number >= 20 then
  begin
    Result := Result + tens[number div 10];
    number := number mod 10;
    if number > 0 then
      Result := Result + '-';
  end;
  if (0 < number) and (number < 20) then
    Result := Result + smallies[number];
end;

function spell(number: int64): string;
var
  scaleFactor: int64;
  maxieStart, h: int64;
begin
  Result := '';
  if number < 0 then
  begin
    number := -number;
    Result := 'negative ';
  end;
  scaleFactor := 1000000000000000000;
  maxieStart := 5;
  if number < 20 then
     exit(Result+smallies[number]);
  while scaleFactor > 0 do
  begin
    if number > scaleFactor then
    begin
      h := number div scaleFactor;
      Result := Result + doHundreds(h) + domaxies(maxieStart);
      number := number mod scaleFactor;
      if number > 0 then
        Result := Result + ', ';
    end;
    scaleFactor := scaleFactor div 1000;
    dec(maxieStart);
  end;
end;

begin
  writeln(99, ': ', spell(99));
  writeln(234, ': ', spell(234));
  writeln(7342, ': ', spell(7342));
  writeln(32784, ': ', spell(32784));
  writeln(234345, ': ', spell(234345));
  writeln(2343451, ': ', spell(2343451));
  writeln(23434534, ': ', spell(23434534));
  writeln(234345456, ': ', spell(234345456));
  writeln(2343454569, ': ', spell(2343454569));
  writeln(2343454564356, ': ', spell(2343454564356));
  writeln(2345286538456328, ': ', spell(2345286538456328));
  Readln;
end.
