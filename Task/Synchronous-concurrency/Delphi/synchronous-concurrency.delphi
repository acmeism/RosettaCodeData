program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Windows;

type
  EThreadStackFinalized = class(Exception);

  PLine = ^TLine;
  TLine = record
    Text: string;
  end;

  TThreadQueue = class
  private
    FFinalized: Boolean;
    FQueue: THandle;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Finalize;
    procedure Push(Data: Pointer);
    function Pop(var Data: Pointer): Boolean;
    property Finalized: Boolean read FFinalized;
  end;

  TPrintThread = class(TThread)
  private
    FCount: Integer;
    FTreminateEvent: THandle;
    FDoneEvent: THandle;
    FQueue: TThreadQueue;
  public
    constructor Create(aTreminateEvent, aDoneEvent: THandle; aQueue: TThreadQueue);
    procedure Execute; override;

    property Count: Integer read FCount;
  end;

{ TThreadQueue }

constructor TThreadQueue.Create;
begin
  FQueue := CreateIOCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 0);
  FFinalized := False;
end;

destructor TThreadQueue.Destroy;
begin
  if FQueue <> 0 then
    CloseHandle(FQueue);
  inherited;
end;

procedure TThreadQueue.Finalize;
begin
  PostQueuedCompletionStatus(FQueue, 0, 0, Pointer($FFFFFFFF));
  FFinalized := True;
end;

function TThreadQueue.Pop(var Data: Pointer): Boolean;
var
  A: Cardinal;
  OL: POverLapped;
begin
  Result := True;
  if not FFinalized then
    GetQueuedCompletionStatus(FQueue, A, Cardinal(Data), OL, INFINITE);

  if FFinalized or (OL = Pointer($FFFFFFFF)) then begin
    Data := nil;
    Result := False;
    Finalize;
  end;
end;

procedure TThreadQueue.Push(Data: Pointer);
begin
  if FFinalized then
    raise EThreadStackFinalized.Create('Stack is finalized');

  PostQueuedCompletionStatus(FQueue, 0, Cardinal(Data), nil);
end;

{ TPrintThread }

constructor TPrintThread.Create(aTreminateEvent, aDoneEvent: THandle; aQueue: TThreadQueue);
begin
  inherited Create(True);
  FCount := 0;
  FreeOnTerminate := True;
  FTreminateEvent := aTreminateEvent;
  FDoneEvent := aDoneEvent;
  FQueue := aQueue;
end;

procedure TPrintThread.Execute;
var
  data: Pointer;
  line: PLine;
begin
  repeat
    if FQueue.Pop(data) then begin
      line := data;
      try
        Writeln(line^.Text);
        if line^.Text = #0 then
          SetEvent(FDoneEvent);
        Inc(FCount);
      finally
        Dispose(line);
      end;
    end;

  until False;
  WaitForSingleObject(FTreminateEvent, INFINITE);
end;

var
  PrintThread: TPrintThread;
  Queue: TThreadQueue;
  lines: TStrings;
  i: Integer;
  line: PLine;
  TreminateEvent, DoneEvent: THandle;
begin
  Queue := TThreadQueue.Create;
  try
    TreminateEvent := CreateEvent(nil, False, False, 'TERMINATE_EVENT');
    DoneEvent := CreateEvent(nil, False, False, 'DONE_EVENT');
    try
      PrintThread := TPrintThread.Create(TreminateEvent, DoneEvent, Queue);
      PrintThread.Start;
      lines := TStringList.Create;
      try
        lines.LoadFromFile('input.txt');
        for i := 0 to lines.Count - 1 do begin
          New(line);
          line^.Text := lines[i];
          Queue.Push(line);
        end;

        New(line);
        line^.Text := #0;
        Queue.Push(line);

        WaitForSingleObject(DoneEvent, INFINITE);

        New(line);
        line^.Text := IntToStr(PrintThread.Count);
        Queue.Push(line);

        SetEvent(TreminateEvent);
      finally
        lines.Free;
      end;
    finally
      CloseHandle(TreminateEvent);
      CloseHandle(DoneEvent)
    end;

    Readln;
  finally
    Queue.Free;
  end;
end.
