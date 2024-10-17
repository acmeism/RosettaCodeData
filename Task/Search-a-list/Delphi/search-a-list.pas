program Needle;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

var
  list: TStringList;
  needle: string;
  ind: Integer;
begin
  list := TStringList.Create;
  try
    list.Append('triangle');
    list.Append('fork');
    list.Append('limit');
    list.Append('baby');
    list.Append('needle');

    list.Sort;

    needle := 'needle';
    ind := list.IndexOf(needle);
    if ind < 0 then
      raise Exception.Create('Needle not found')
    else begin
      Writeln(ind);
      Writeln(list[ind]);
    end;

    Readln;
  finally
    list.Free;
  end;
end.
