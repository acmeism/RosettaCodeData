program WizardStaircase;
const
  StartStairLength = 100;
  StairsPerSpell = 5;
  rounds = 10000;

procedure OutActual(trials,behind,infront:longword);
begin
  writeln(trials:5,infront+behind:12,behind:10,inFront:9);
end;

function OneRun(StairsPerSpell:Cardinal;WithOutput:boolean):longword;
var
  inFront,behind,total,i,trials: Cardinal;
begin
  trials := 0;
  total := StartStairLength;
  inFront := total;
  behind := 0;
  repeat
    inc(trials);
    inc(behind);
    dec(infront);
    //spell
    i := StairsPerSpell;
    repeat
      if random(total) < behind then
        inc(behind)
      else
        inc(infront);
      inc(total);
      dec(i);
    until i=0;
    if WithOutput then
    begin
      if (trials <= 609)AND(trials>=600) then
        OutActual(trials,behind,infront);
    end;
  until infront = 0;
  OneRun := total;
end;

procedure CheckDouble(StairsPerSpell:Cardinal);
var
  behind,infront,relpos,total,One,relSpell : double;
  i : LongInt;
begin
  write(StairsPerSpell:3);
  One := 1.0;
  behind := 0.0;
  inFront  := StartStairLength;
  total    := StartStairLength;
  relSpell := One/StairsPerSpell;
  repeat
    i := StairsPerSpell;
    //doing a partial move per one stair per spell
    repeat
      relpos  := (behind+relSpell)/total;
      behind  := behind +     relpos +relSpell;
      inFront := inFront+(One-relpos)-relSpell;
      total   := total+One;
      dec(i);
    until i= 0;
  until infront < One;
  writeln((total-StartStairLength)/StairsPerSpell:10:0,total:14:0);
end;

var
  i,
  mySpell,
  attempt,
  minStairs,
  maxStairs,
  total : longword;
begin
  randomize;
  writeln('Seconds  steps total  behind    ahead');
  total := OneRun(StairsPerSpell,true);

  writeln('      average stairs needed steps minimum   maximum');
  for mySpell := 1 to 7 do
  begin
    write(mySpell:3,'  ');
    total := 0;
    minStairs := High(minStairs);
    maxStairs := low(maxStairs);
    For i := rounds-1 downto 0 do
    begin
      attempt:= OneRun(mySpell,false);
      if minStairs>attempt then
        minstairs := attempt;
      if maxStairs<attempt then
        maxstairs := attempt;
      inc(total,attempt);
    end;
    writeln((total-StartStairLength)/rounds/mySpell:12:3,total/rounds:14:3,minStairs:9,maxStairs:10);
  end;
  writeln;

  writeln(' calculated ');
  For i := 1 to 10 do
    CheckDouble(i);
end.
