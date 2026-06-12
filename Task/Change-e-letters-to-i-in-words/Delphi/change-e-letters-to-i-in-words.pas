program Change_e_letters_to_i_in_words;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

var
  Result: TStringList;

begin
  with TStringList.Create do
  begin
    LoadFromFile('unixdict.txt');
    for var i := Count - 1 downto 0 do
      if (Strings[i].Length < 6) then
        Delete(i);

    Result := TStringList.Create;

    for var i := Count - 1 downto 0 do
    begin
      var w_e := Strings[i];

      if w_e.IndexOf('e') = -1 then
        continue;

      var w_i := w_e.Replace('e', 'i', [rfReplaceAll]);
      if IndexOf(w_i) > -1 then
        Result.Add(format('%s ──► %s', [w_e.PadRight(12), w_i]));
    end;

    Result.Sort;
    writeln(Result.Text);
    Free;
  end;

  readln;
end.
