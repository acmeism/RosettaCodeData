program Words_containing_the_substring;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils;

var
  Words, WordsFound: TArray<string>;

begin
  Words := TFile.ReadAllLines('unixdict.txt');

  for var w in Words do
  begin
    if (w.Length > 11) and (w.IndexOf('the') > -1) then
    begin
      SetLength(WordsFound, Length(WordsFound) + 1);
      WordsFound[High(WordsFound)] := w;
    end;
  end;
  writeln('Words containing "the" having a length > 11 in unixdict.txt:');

  for var i := 0 to High(WordsFound) do
    writeln(i + 1: 2, ': ', WordsFound[i]);

  readln;
end.
