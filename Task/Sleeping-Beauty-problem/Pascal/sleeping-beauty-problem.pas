program sleepBeau;
uses
  sysutils; //Format
const
  iterations = 1000*1000;
fmt = 'Wakings over %d repetitions = %d'+#13#10+
      'Percentage probability of heads on waking = %8.5f%%';
var
  i,
  heads,
  wakings,
  flip: Uint32;
begin
  randomize;
  for i :=1 to iterations do
  Begin
    flip := random(2)+1;//-- 1==heads, 2==tails
    inc(wakings,1 + Ord(flip=2));
    inc(heads,Ord(flip=1));
  end;
  writeln(Format(fmt,[iterations,wakings,heads/wakings*100]));
end.
