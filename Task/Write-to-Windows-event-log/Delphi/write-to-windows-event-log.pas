program WriteToEventLog;

{$APPTYPE CONSOLE}

uses Windows;

procedure WriteLog(aMsg: string);
var
  lHandle: THandle;
  lMessagePtr: Pointer;
begin
  lMessagePtr := PChar(aMsg);
  lHandle := RegisterEventSource(nil, 'Logger');
  if lHandle > 0 then
  begin
    try
      ReportEvent(lHandle, 4 {Information}, 0, 0, nil, 1, 0, @lMessagePtr, nil);
    finally
      DeregisterEventSource(lHandle);
    end;
  end;
end;

begin
  WriteLog('Message to log.');
end.
