program Longest_Common_Substring;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

function lcs(x, y: string): string;
var
  n, m, Alength: Integer;
  t, common: string;
  j: Integer;
  k: Integer;
begin

  Result := '';
  Alength := x.Length;

  for j := 0 to Alength - 1 do
    for k := Alength - j downto 0 do
    begin
      common := x.Substring(j, k);
      if (y.IndexOf(common) > -1) and (common.Length > Result.Length) then
        Result := common;
    end;
end;

var
  a, b: string;

begin
  a := 'thisisatest';
  b := 'testing123testing';
  if ParamCount = 2 then
  begin
    if not ParamStr(1).IsEmpty then
      a := ParamStr(1);
    if not ParamStr(2).IsEmpty then
      b := ParamStr(2);
  end;

  Writeln('string A = ', a);
  Writeln('string B = ', b);
  Writeln('LCsubstr = ', lcs(a, b));
  readln;
end.
