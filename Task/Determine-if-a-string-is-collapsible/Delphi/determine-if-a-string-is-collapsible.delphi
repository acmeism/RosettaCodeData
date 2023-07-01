program Determine_if_a_string_is_collapsible;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure collapsible(s: string);
var
  c, last: char;
  len: Integer;
begin
  writeln('old: <<<', s, '>>>, length = ', s.length);
  write('new: <<<');
  last := #0;
  len := 0;
  for c in s do
  begin
    if c <> last then
    begin
      write(c);
      inc(len);
    end;
    last := c;
  end;
  writeln('>>>, length = ', len, #10);
end;

begin
  collapsible('');
  collapsible('"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ');
  collapsible('..1111111111111111111111111111111111111111111111111111111111111117777888');
  collapsible('I never give ''em hell, I just tell the truth, and they think it''s hell. ');
  collapsible('                                                    --- Harry S Truman  ');
  readln;
end.
