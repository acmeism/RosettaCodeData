var Position: integer;

function Step(Memo: TMemo): boolean;
begin
Result:=Random(2)=1;
if Result then Inc(Position)
else Dec(Position);
If Result then Memo.Lines.Add(Format('Climbed up to %d', [Position]))
else Memo.Lines.Add(Format('Fell down to %d', [Position]));
end;


procedure StepUp(Memo: TMemo);
begin
while not Step(Memo) do StepUp(Memo);
end;


procedure ShowStairClimb(Memo: TMemo);
begin
Position:=0;
Randomize;
StepUp(Memo);
end;
