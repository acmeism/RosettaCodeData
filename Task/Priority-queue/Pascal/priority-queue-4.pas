program PqDemo;
{$mode delphi}
uses
  SysUtils, PQueue;

type
  TTask = record
    Name: string; Prio: Integer;
  end;

const
  Tasks: array of TTask = [
    (Name: 'Clear drains';   Prio: 3), (Name: 'Feed cat';       Prio: 4),
    (Name: 'Make tea';       Prio: 5), (Name: 'Solve RC tasks'; Prio: 1),
    (Name: 'Tax return';     Prio: 2)];

function TaskCmp(const L, R: TTask): Boolean;
begin
  Result := L.Prio < R.Prio;
end;

var
  q: TPriorityQueue<TTask>;
  h: q.THandle = q.NULL_HANDLE;
  t: TTask;
  MaxPrio: Integer = Low(Integer);
begin
  Randomize;
  q := TPriorityQueue<TTask>.Create(@TaskCmp);
  for t in Tasks do begin
    if t.Prio > MaxPrio then MaxPrio := t.Prio;
    if Pos('cat', t.Name) > 0 then
      h := q.Push(t)
    else
      q.Push(t);
  end;
  if (h <> q.NULL_HANDLE) and Boolean(Random(2)) then begin
    WriteLn('Cat is angry!');
    t := q.GetValue(h);
    t.Prio := Succ(MaxPrio);
    q.Update(h, t);
  end;
  WriteLn('Task list:');
  while q.TryPop(t) do
    WriteLn('  ', t.Prio, ' ', t.Name);
  q.Free;
end.
