program UserInputGraphical;

{$APPTYPE CONSOLE}

uses SysUtils, Dialogs;

var
  s: string;
  lStringValue: string;
  lIntegerValue: Integer;
begin
  lStringValue := InputBox('User input/Graphical', 'Enter a string', '');

  repeat
    s := InputBox('User input/Graphical', 'Enter the number 75000', '75000');
    lIntegerValue := StrToIntDef(s, 0);
    if lIntegerValue <> 75000 then
      ShowMessage('Invalid entry: ' + s);
  until lIntegerValue = 75000;
end.
