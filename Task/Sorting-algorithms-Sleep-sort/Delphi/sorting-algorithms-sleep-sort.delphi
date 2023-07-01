program SleepSortDemo;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils, Classes;

type
  TSleepThread = class(TThread)
  private
    FValue: Integer;
    FLock: PRTLCriticalSection;
  protected
    constructor Create(AValue: Integer; ALock: PRTLCriticalSection);
    procedure Execute; override;
  end;

constructor TSleepThread.Create(AValue: Integer; ALock: PRTLCriticalSection);
begin
  FValue:= AValue;
  FLock:= ALock;
  inherited Create(False);
end;

procedure TSleepThread.Execute;
begin
  Sleep(1000 * FValue);
  EnterCriticalSection(FLock^);
  Write(FValue:3);
  LeaveCriticalSection(FLock^);
end;

var
  A: array[0..15] of Integer;
  Handles: array[0..15] of THandle;
  Threads: array[0..15] of TThread;
  Lock: TRTLCriticalSection;
  I: Integer;

begin
  for I:= Low(A) to High(A) do
    A[I]:= Random(15);
  for I:= Low(A) to High(A) do
    Write(A[I]:3);
  Writeln;

  InitializeCriticalSection(Lock);
  for I:= Low(A) to High(A) do begin
    Threads[I]:= TSleepThread.Create(A[I], @Lock);
    Handles[I]:= Threads[I].Handle;
  end;
  WaitForMultipleObjects(Length(A), @Handles, True, INFINITE);
  for I:= Low(A) to High(A) do
    Threads[I].Free;
  DeleteCriticalSection(Lock);

  Writeln;
  ReadLn;
end.
