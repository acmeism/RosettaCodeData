program dining_philosophers;
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
type
  TPhilosopher = class(TThread)
  private
    FName: string;
    FFirstFork, FSecondFork: TFork;
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
      WriteLn(FName, ' sits down at the table');
      FFirstFork.Acquire;
      FSecondFork.Acquire;
      WriteLn(FName, ' eating');
      Sleep(Random(DELAY_RANGE) + DELAY_LOW);
      FSecondFork.Release;
      FFirstFork.Release;
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
  if aForkIdx1 < aForkIdx2 then
    begin
      FFirstFork := Forks[aForkIdx1];
      FSecondFork := Forks[aForkIdx2];
    end
  else
    begin
      FFirstFork := Forks[aForkIdx2];
      FSecondFork := Forks[aForkIdx1];
    end;
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
