program Determine_if_a_string_has_all_unique_characters;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure string_has_repeated_character(str: string);
var
  len, i, j: Integer;
begin
  len := length(str);
  Writeln('input: \', str, '\, length: ', len);
  for i := 1 to len - 1 do
  begin
    for j := i + 1 to len do
    begin
      if str[i] = str[j] then
      begin
        Writeln('String contains a repeated character.');
        Writeln('Character "', str[i], '" (hex ', ord(str[i]).ToHexString,
          ') occurs at positions ', i + 1, ' and ', j + 1, '.'#10);
        Exit;
      end;
    end;
  end;
  Writeln('String contains no repeated characters.' + sLineBreak);
end;

begin
  string_has_repeated_character('');
  string_has_repeated_character('.');
  string_has_repeated_character('abcABC');
  string_has_repeated_character('XYZ ZYX');
  string_has_repeated_character('1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ');
  readln;
end.
