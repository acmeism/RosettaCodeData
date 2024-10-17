program OneInstance;

{$APPTYPE CONSOLE}

uses SysUtils, Windows;

var
  FMutex: THandle;
begin
  FMutex := CreateMutex(nil, True, 'OneInstanceMutex');
  if FMutex = 0 then
    RaiseLastOSError
  else
  begin
    try
      if GetLastError = ERROR_ALREADY_EXISTS then
        Writeln('Program already running.  Closing...')
      else
      begin
        // do stuff ...
        Readln;
      end;
    finally
      CloseHandle(FMutex);
    end;
  end;
end.
