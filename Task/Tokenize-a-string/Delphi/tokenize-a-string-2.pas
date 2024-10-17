program TokenizeString;

{$APPTYPE CONSOLE}

uses
  Classes;

var
  tmp: TStringList;
  i: Integer;

begin

  // Instantiate TStringList class
  tmp := TStringList.Create;
  try
    { Use the TStringList's CommaText property to get/set
      all the strings in a single comma-delimited string }
    tmp.CommaText := 'Hello,How,Are,You,Today';

    { Now loop through the TStringList and display each
      token on the console }
    for i := 0 to Pred(tmp.Count) do
      Writeln(tmp[i]);

  finally
    tmp.Free;
  end;

  Readln;

end.
