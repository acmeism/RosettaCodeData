program Text_between;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function TextBetween(source, bg, ed: string): string;
var
  startIndex, edIndex: Integer;
begin
  if bg = 'start' then
    startIndex := 0
  else
  begin
    startIndex := source.IndexOf(bg);
    if startIndex < 0 then
      Exit('');

    startIndex := startIndex + bg.Length;
  end;
  edIndex := source.IndexOf(ed, startIndex);

  if (edIndex < 0) or (ed = 'end') then
    Exit(source.Substring(startIndex));
  Exit(source.Substring(startIndex, edIndex - startIndex));
end;

procedure Print(s, b, e: string; var ExempleIndex: Integer);
begin
  Writeln('Exemple ', ExempleIndex, ':');
  Writeln(Format('Text:   "%s"', [s]));
  Writeln(Format('Start:  "%s"', [b]));
  Writeln(Format('End:    "%s"', [e]));
  Writeln(Format('Result: "%s"'#10, [TextBetween(s, b, e)]));
  inc(ExempleIndex);
end;

var
  ExempleIndex: Integer = 1;

begin
  Print('Hello Rosetta Code world', 'Hello ', ' world', ExempleIndex);

  Print('Hello Rosetta Code world', 'start', ' world', ExempleIndex);

  Print('Hello Rosetta Code world', 'Hello ', 'end', ExempleIndex);

  Print('</div><div style=\"chinese\">你好嗎</div>', '<div style=\"chinese\">',
    '</div>', ExempleIndex);

  Print('<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">',
    '<text>', '<table>', ExempleIndex);

  Print('<table style=\"myTable\"><tr><td>hello world</td></tr></table>',
    '<table>', '</table>', ExempleIndex);

  Print('The quick brown fox jumps over the lazy other fox', 'quick ', ' fox',
    ExempleIndex);

  Print('One fish two fish red fish blue fish', 'fish ', ' red', ExempleIndex);

  Print('FooBarBazFooBuxQuux', 'Foo', 'Foo', ExempleIndex);

  Readln;
end.
