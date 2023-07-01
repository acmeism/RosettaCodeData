program Four_is_magic;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

// https://rosettacode.org/wiki/Number_names#Delphi
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
  if number = 0 then
    exit('zero');

  scaleFactor := 1000000000000000000;
  Result := '';
  if number < 0 then
  begin
    number := -number;
    Result := 'negative ';
  end;

  maxieStart := 5;
  if number < 20 then
    exit(smallies[number]);
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
//****************************************************\\

const
  numbers: array of Int64 = [0, 4, 6, 11, 13, 75, 100, 337, -164, int64.MaxValue];

function fourIsMagic(n: int64): string;
var
  s: string;
begin
  s := spell(n);
  s[1] := upcase(s[1]);
  var t := s;

  while n <> 4 do
  begin
    n := s.Length;
    s := spell(n);
    t := t + ' is ' + s + ', ' + s;
  end;
  t := t + ' is magic.';
  exit(t);
end;

begin
//  writeln(spell(4));
  for var n in numbers do
    writeln(fourIsMagic(n));
  readln;
end.
