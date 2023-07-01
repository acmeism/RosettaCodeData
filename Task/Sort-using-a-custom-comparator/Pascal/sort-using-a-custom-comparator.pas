program CustomComparator;
{$mode objfpc}{$h+}
uses
  Classes, SysUtils, Math;

function Compare(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := CompareValue(Length(List[Index2]), Length(List[Index1]));
  if Result = 0 then
    Result := CompareText(List[Index1], List[Index2]);
end;

const
  Sample = 'Here are some sample strings to be sorted';

begin
  with TStringList.Create do
    try
      AddStrings(Sample.Split([' '], TStringSplitOptions.ExcludeEmpty));
      CustomSort(@Compare);
      WriteLn(string.Join(', ', ToStringArray));
    finally
      Free;
    end;
  Readln;
end.
