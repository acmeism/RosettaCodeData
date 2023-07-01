program reverse_words;
{$mode objfpc}{$h+}
uses
  SysUtils;

function Reverse(a: TStringArray): TStringArray;
var
  I, J: SizeInt;
  t: Pointer;
begin
  I := 0;
  J := High(a);
  while I < J do begin
    t := Pointer(a[I]);
    Pointer(a[I]) := Pointer(a[J]);
    Pointer(a[J]) := t;
    Inc(I);
    Dec(J);
  end;
  Result := a;
end;

const
  Input =
    '---------- Ice and Fire -----------'  + LineEnding +
                                        '' + LineEnding +
    'fire, in end will world the say Some' + LineEnding +
    'ice. in say Some'                     + LineEnding +
    'desire of tasted I''ve what From'     + LineEnding +
    'fire. favor who those with hold I'    + LineEnding +
                                        '' + LineEnding +
    '... elided paragraph last ...'        + LineEnding +
                                        '' + LineEnding +
    'Frost Robert -----------------------' + LineEnding;
var
  Line: string;

begin
  for Line in Input.Split([LineEnding], TStringSplitOptions.ExcludeLastEmpty) do
    WriteLn(string.Join(' ', Reverse(Line.Split([' ']))));
end.
