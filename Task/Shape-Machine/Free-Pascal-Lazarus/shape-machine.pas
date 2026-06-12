program ShapeMachine;
const
  offset = 3.0;
  factor = 0.86;
var
  before, after: extended;
  iterationsCount: uint32;
begin
  //x = (x+offset)*factor
  //x/factor-x = offset
  //x := offset/(1/factor-1) -> factor must be smaller than 1
  after := 4;
//  after := offset/(1/factor-1);
  iterationsCount := 0;
  Writeln('Start with value ',after);
  repeat
    before := after;
    after := (before + offset) * factor;
    Inc(iterationsCount);
  until before = after;
  writeln(before: 0: 20, ' after ', iterationsCount, ' iterations');
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
