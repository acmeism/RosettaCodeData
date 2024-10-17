program CreateHTMLTable;

{$APPTYPE CONSOLE}

uses SysUtils;

function AddTableRow(aRowNo: Integer): string;
begin
  Result := Format('  <tr><td>%d</td><td>%d</td><td>%d</td><td>%d</td></tr>',
    [aRowNo, Random(10000), Random(10000), Random(10000)]);
end;

var
  i: Integer;
begin
  Randomize;
  Writeln('<table>');
  Writeln('  <tr><th></th><th>X</th><th>Y</th><th>Z</th></tr>');
  for i := 1 to 4 do
    Writeln(AddTableRow(i));
  Writeln('</table>');
  Readln;
end.
