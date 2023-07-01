program Project1;

{$H+}//Use ansistrings
uses
  Classes,
  SysUtils,
  StrUtils;

  procedure AlignByColumn(Align: TAlignment);
  const
    TextToAlign =
      'Given$a$text$file$of$many$lines,$where$fields$within$a$line$'#$D#$A +
      'are$delineated$by$a$single$''dollar''$character,$write$a$program'#$D#$A +
      'that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$'#$D#$A +
      'column$are$separated$by$at$least$one$space.'#$D#$A +
      'Further,$allow$for$each$word$in$a$column$to$be$either$left$'#$D#$A +
      'justified,$right$justified,$or$center$justified$within$its$column.';
  var
    TextLine: TStringList;
    TextLines: array of TStringList;
    OutPutString, EmptyString, Item: string;
    MaxLength, i, j: Int32;
  begin
    try
      MaxLength := 0;
      TextLine := TStringList.Create;
      TextLine.Text := TextToAlign;
      setlength(Textlines, TextLine.Count);
      for i := 0 to TextLine.Count - 1 do
      begin
        Textlines[i] := TStringList.Create;
        Textlines[i].Text := AnsiReplaceStr(TextLine[i], '$', #$D#$A);
      end;

      for i := 0 to High(TextLines) do
        for j := 0 to Textlines[i].Count - 1 do
          if MaxLength < Length(TextLines[i][j]) then
            MaxLength := Length(TextLines[i][j]);
      if MaxLength > 0 then
        MaxLength := MaxLength + 2; // Add two empty spaces to it

      for i := 0 to High(TextLines) do
      begin
        OutPutString := '';
        for j := 0 to Textlines[i].Count - 1 do
        begin
          EmptyString := StringOfChar(' ', MaxLength);
          if j <> 0 then
            EmptyString[1] := '|';
          Item := TextLines[i][j];
          case Align of
            taLeftJustify: Move(Item[1], EmptyString[2], Length(Item));
            taRightJustify: Move(Item[1], EmptyString[MaxLength - Length(Item) + 1],
                Length(Item));
            taCenter: Move(Item[1], EmptyString[(MaxLength - Length(Item) + 1) div
                2 + 1], Length(Item));
          end;
          OutPutString := OutPutString + EmptyString;
        end;
        writeln(OutPutString);
      end;
    finally
      writeln;
      FreeAndNil(TextLine);
      for i := High(TextLines) downto 0 do
        FreeAndNil(TextLines[i]);
    end;
  end;

begin
  AlignByColumn(taLeftJustify);
  AlignByColumn(taCenter);
  AlignByColumn(taRightJustify);
end.
