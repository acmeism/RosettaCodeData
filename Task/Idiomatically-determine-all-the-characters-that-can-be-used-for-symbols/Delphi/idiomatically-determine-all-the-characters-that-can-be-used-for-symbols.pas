procedure ShowValidSymbols(Memo: TMemo);
{Uses Delphi system tool "IsValidIndent" }
{To identify valid characters in indentifiers}
var I: integer;
var TS: string;
var Good,Bad: string;
begin
{Test first characters in a symbol}
Good:=''; Bad:='';
for I:=$21 to $7F do
	begin
	TS:=Char(I);
	if IsValidIdent(TS) then Good:=Good+TS
	else Bad:=Bad+TS;
	end;
Memo.Lines.Add('First Characters Allowed');
Memo.Lines.Add('Allowed:      '+Good);
Memo.Lines.Add('Not Allowed:  '+Bad);
{Test remaining characters in a symbol}
Good:=''; Bad:='';
for I:=$21 to $7F do
	begin
	TS:='A'+Char(I);
	if IsValidIdent(TS) then Good:=Good+TS[2]
	else Bad:=Bad+TS[2];
	end;
Memo.Lines.Add('');
Memo.Lines.Add('Remaining Characters Allowed');
Memo.Lines.Add('Allowed:      '+Good);
Memo.Lines.Add('Not Allowed:  '+Bad);
end;
