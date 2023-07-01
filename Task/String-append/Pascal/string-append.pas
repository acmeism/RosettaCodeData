program StringAppend;
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

var
    s: String = 'Hello';
begin
  s += ' World !';
  WriteLn(S);
  ReadLn;
end.
