program Delegate;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Printer in 'Printer.pas';

var
  PrinterObj: TPrinter;
begin
  PrinterObj:= TPrinter.Create;
  try
    PrinterObj.Print;
    Readln;
  finally
    PrinterObj.Free;
  end;
end.
