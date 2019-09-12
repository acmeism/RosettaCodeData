program dining_philosophers4;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, SyncObjs;
const
  PHIL_COUNT   = 5;
  LIFESPAN     = 7;
  DELAY_RANGE  = 950;
  DELAY_LOW    = 50;
  PHIL_NAMES: array[1..PHIL_COUNT] of string = ('Aristotle', 'Kant', 'Spinoza', 'Marx', 'Russell');
type
  TFork        = TCriticalSection;
  TPhilosopher = class;
var
  Forks: array[1..PHIL_COUNT] of TFork;
  Philosophers: array[1..PHIL_COUNT] of TPhilosopher;
  StilDining: Integer = 0;
procedure WaitForPlaceFree;
begin
  repeat
    if InterlockedIncrement(StilDining) > Pred(PHIL_COUNT) then
      begin
        InterlockedDecrement(StilDining);
        Sleep(Random(DELAY_LOW));
        continue;
      end;
    exit;
  until False;
end;

procedure FreePlace;
begin
  InterLockedDecrement(StilDining);
end;

type
  TPhilosopher = class(TThread)
  private
    FName: string;
    FLeftFork, FRightFork: TFork;
  protected
    procedure Execute; override;
  public
    constructor Create(const aName: string; aForkIdx1, aForkIdx2: Integer);
  end;

procedure TPhilosopher.Execute;
var
  LfSpan: Integer = LIFESPAN;
begin
  while LfSpan > 0 do
    begin
      Dec(LfSpan);
      WaitForPlaceFree;
      WriteLn(FName, ' sits down at the table');
      FLeftFork.Acquire;
      FRightFork.Acquire;
      WriteLn(FName, ' eating');
      Sleep(Random(DELAY_RANGE) + DELAY_LOW);
      FRightFork.Release;
      FLeftFork.Release;
      FreePlace;
      WriteLn(FName, ' is full and leaves the table');
      if LfSpan = 0 then
        continue;
      WriteLn(FName, ' thinking');
      Sleep(Random(DELAY_RANGE) + DELAY_LOW);
      WriteLn(FName, ' is hungry');
    end;
end;

constructor TPhilosopher.Create(const aName: string; aForkIdx1, aForkIdx2: Integer);
begin
  inherited Create(True);
  FName := aName;
  FLeftFork := Forks[aForkIdx1];
  FRightFork := Forks[aForkIdx2];
end;

procedure DinnerBegin;
var
  I: Integer;
  Phil: TPhilosopher;
begin
  for I := 1 to PHIL_COUNT do
    Forks[I] := TFork.Create;
  for I := 1 to PHIL_COUNT do
    Philosophers[I] := TPhilosopher.Create(PHIL_NAMES[I], I, Succ(I mod PHIL_COUNT));
  for Phil in Philosophers do
    Phil.Start;
end;

procedure WaitForDinnerOver;
var
  Phil: TPhilosopher;
  Fork: TFork;
begin
  for Phil in Philosophers do
    begin
      Phil.WaitFor;
      Phil.Free;
    end;
  for Fork in Forks do
    Fork.Free;
end;

begin
  Randomize;
  DinnerBegin;
  WaitForDinnerOver;
end.
