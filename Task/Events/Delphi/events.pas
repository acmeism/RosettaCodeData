program Events;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Windows;

type
  TWaitThread = class(TThread)
  private
    FEvent: THandle;
  public
    procedure Sync;
    procedure Execute; override;
    constructor Create(const aEvent: THandle); reintroduce;
  end;

{ TWaitThread }

constructor TWaitThread.Create(const aEvent: THandle);
begin
  inherited Create(False);
  FEvent := aEvent;
end;

procedure TWaitThread.Execute;
var
  res: Cardinal;
begin
  res := WaitForSingleObject(FEvent, INFINITE);
  if res = 0 then
    Synchronize(Sync);
end;

procedure TWaitThread.Sync;
begin
  Writeln(DateTimeToStr(Now));
end;

var
  event: THandle;

begin
  Writeln(DateTimeToStr(Now));
  event := CreateEvent(nil, False, False, 'Event');
  with TWaitThread.Create(event) do
  try
    Sleep(1000);
    SetEvent(event)
  finally
    Free;
  end;
  Readln;
end.
