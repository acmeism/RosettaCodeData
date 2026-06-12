program maximumDifferenceBetweenAdjacentElementsOfList(output);
type
  tmyReal = extended;
  tmyList = array of tmyReal;
const
  input: tmyList = (1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3);
  procedure  OutSameDistanceInList(Dist:tmyReal;const list: tmyList);
  var
    currentDistance : tmyReal;
    i : integer;
  begin
    for i := 0 to High(List) - 1 do
    begin
      currentDistance := abs(list[i] - list[succ(i)]);
      if currentDistance = dist then
         writeln('idx : ',i:4,' values ',list[i],' ',list[i+1]);
    end;
    writeln;
  end;

  function internalDistance(const list: tmyList): tmyReal;
  var
    i: integer;
    maximumDistance, currentDistance: tmyReal;
  begin
    maximumDistance := 0.0;
    for i := 0 to High(List) - 1 do
    begin
      currentDistance := abs(list[i] - list[succ(i)]);
      if currentDistance > maximumDistance then
      begin
        maximumDistance := currentDistance;
      end;
    end;
    internalDistance := maximumDistance;
  end;

var
  list: tmyList;
  foundDistance : tmyReal;
begin
  list := input;
  if length(list) > 0 then
  Begin
    foundDistance := internalDistance(list);
    OutSameDistanceInList(foundDistance,list);
  end;
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
