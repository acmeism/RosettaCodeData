USES
   StdCtrls, Classes, SysUtils, StrUtils, Contnrs;

procedure AlignByColumn(Output: TMemo; Align: TAlignment);
const
   TextToAlign =
   'Given$a$text$file$of$many$lines,$where$fields$within$a$line$'#$D#$A +
   'are$delineated$by$a$single$''dollar''$character,$write$a$program'#$D#$A +
   'that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$'#$D#$A +
   'column$are$separated$by$at$least$one$space.'#$D#$A +
   'Further,$allow$for$each$word$in$a$column$to$be$either$left$'#$D#$A +
   'justified,$right$justified,$or$center$justified$within$its$column.';
var
   TextLine, TempTString: TStringlist;
   TextLines: TObjectList;
   MaxLength, i, j: Byte;
   OutPutString, EmptyString, Item: String;
begin
   TRY
      MaxLength := 0;
      TextLines := TObjectList.Create(True);
      TextLine := TStringList.Create;
      TextLine.text := TextToAlign;
      for i:= 0 to TextLine.Count - 1 do
      begin
         TempTString := TStringlist.create;
         TempTString.text :=AnsiReplaceStr(TextLine[i], '$', #$D#$A);
         TextLines.Add(TempTString);
      end;
      for i := 0 to TextLines.Count - 1 do
         for j := 0 to TStringList(TextLines.Items[i]).Count - 1 do
            If Length(TStringList(TextLines.Items[i])[j]) > MaxLength then
               MaxLength := Length(TStringList(TextLines.Items[i])[j]);
      If MaxLength > 0 then
         MaxLength := MaxLength + 2; // Add to empty spaces to it
      for i := 0 to TextLines.Count - 1 do
      begin
         OutPutString := '';
         for j := 0 to TStringList(TextLines.Items[i]).Count - 1 do
         begin
            EmptyString := StringOfChar(' ', MaxLength);
            Item := TStringList(TextLines.Items[i])[j];
            case Align of
               taLeftJustify: Move(Item[1], EmptyString[2], Length(Item));
               taRightJustify: Move(Item[1], EmptyString[MaxLength - Length(Item) + 1], Length(Item));
               taCenter: Move(Item[1], EmptyString[(MaxLength - Length(Item) + 1) div 2 + 1], Length(Item));
            end;
            OutPutString := OutPutString + EmptyString;
         end;
         Output.Lines.Add(OutPutString);
      end;
   FINALLY
      FreeAndNil(TextLine);
      FreeAndNil(TextLines);
   END;
end;
