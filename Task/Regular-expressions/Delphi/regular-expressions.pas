program Regular_expressions;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.RegularExpressions;

const
  CPP_IF = '\s*if\s*\(\s*(?<COND>.*)\s*\)\s*\{\s*return\s+(?<RETURN>.+);\s*\}';
  PASCAL_IF = 'If ${COND} then result:= ${RETURN};';

var
  RegularExpression: TRegEx;
  str: string;

begin
  str := ' if ( a < 0 ) { return -a; }';

  Writeln('Expression: '#10#10, str);

  if RegularExpression.Create(CPP_IF).IsMatch(str) then
  begin
    Writeln(#10'   Is a single If in Cpp:'#10);

    Writeln('Translate to Pascal:'#10);
    str := RegularExpression.Create(CPP_IF).Replace(str, PASCAL_IF);
    Writeln(str);
  end;
  readln;
end.
