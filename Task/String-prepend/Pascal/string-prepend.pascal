program StringPrepend;
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

var
  s: String = ' World !';
begin
  s := 'Hello' + s;
  WriteLn(S);
  ReadLn;
end.
