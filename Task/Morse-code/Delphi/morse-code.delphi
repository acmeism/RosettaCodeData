program Morse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Generics.Collections,
  SysUtils,
  Windows;

const
  Codes: array[0..35, 0..1] of string =
   (('a', '.-   '), ('b', '-... '), ('c', '-.-. '), ('d', '-..  '),
    ('e', '.    '), ('f', '..-. '), ('g', '--.  '), ('h', '.... '),
    ('i', '..   '), ('j', '.--- '), ('k', '-.-  '), ('l', '.-.. '),
    ('m', '--   '), ('n', '-.   '), ('o', '---  '), ('p', '.--. '),
    ('q', '--.- '), ('r', '.-.  '), ('s', '...  '), ('t', '-    '),
    ('u', '..-  '), ('v', '...- '), ('w', '.--  '), ('x', '-..- '),
    ('y', '-.-- '), ('z', '--.. '), ('0', '-----'), ('1', '.----'),
    ('2', '..---'), ('3', '...--'), ('4', '....-'), ('5', '.....'),
    ('6', '-....'), ('7', '--...'), ('8', '---..'), ('9', '----.'));
var
  Dictionary: TDictionary<String, String>;

procedure InitCodes;
var
  i: Integer;
begin
  for i := 0 to High(Codes) do
    Dictionary.Add(Codes[i, 0], Codes[i, 1]);
end;

procedure SayMorse(const Word: String);
var
  s: String;
begin
  for s in Word do
    if s = '.' then
      Windows.Beep(1000, 250)
    else if s = '-' then
      Windows.Beep(1000, 750)
    else
      Windows.Beep(1000, 1000);
end;

procedure ParseMorse(const Word: String);
var
  s, Value: String;
begin
  for s in word do
    if Dictionary.TryGetValue(s, Value) then
    begin
      Write(Value + ' ');
      SayMorse(Value);
    end;
end;

begin
  Dictionary := TDictionary<String, String>.Create;
  try
    InitCodes;
    if ParamCount = 0 then
      ParseMorse('sos')
    else if ParamCount = 1 then
      ParseMorse(LowerCase(ParamStr(1)))
    else
      Writeln('Usage: Morse.exe anyword');

    Readln;
  finally
    Dictionary.Free;
  end;
end.
