program ABC_words;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IoUtils;

var
  bi, ai, i: Integer;
  chars, item: string;
  ch: char;
  skip: boolean;

begin
  bi := 0;
  i := 0;
  chars := 'abc';

  if ParamCount > 0 then
    chars := ParamStr(1);

  writeln('Search words with letters "', chars, '"  in alphabetical order'#10);

  for item in TFile.ReadAllLines('unixdict.txt') do
  begin
    ai := -1;
    skip := false;
    for ch in chars do
    begin
      bi := item.IndexOf(ch);
      if bi > ai then
      begin
        ai := bi;
      end
      else
      begin
        skip := true;
        Break;
      end;
    end;

    if not skip then
    begin
      inc(i);
      write(i: 3, ' ', item.PadRight(18));
      if i mod 5 = 0 then
        writeln;
    end;
  end;


  {$IFNDEF UNIX} readln; {$ENDIF}
end.
