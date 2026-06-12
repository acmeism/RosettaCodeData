type
  DayOfWeek = (Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday);
  Colors = (Red,Green,Blue,Yellow,White);

function Elements145<T>(sq: sequence of T): sequence of T;
begin
  var en := sq.GetEnumerator;
  en.MoveNext;
  yield en.Current;
  en.MoveNext;
  en.MoveNext;
  en.MoveNext;
  yield en.Current;
  en.MoveNext;
  yield en.Current;
end;

function Elements145FromTheEnd<T>(sq: sequence of T): sequence of T
  := Elements145(sq.Reverse);

begin
  var a := Arr(Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday);
  var L := Lst(Red,Green,White,Blue,Yellow);
  a.Println;
  L.Println;
  Elements145(a).Println;
  Elements145(L).Println;
  Elements145FromTheEnd(a).Println;
  Elements145FromTheEnd(L).Println;
end.
