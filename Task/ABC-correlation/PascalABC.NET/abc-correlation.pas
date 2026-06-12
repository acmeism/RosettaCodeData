// ABC correlation. Nigel Galloway: September 3rd., 2024
function predicate(g:Sequence of (integer,integer);m:integer):boolean;
begin
  result:=false; if g.First[0]<m then exit;
  foreach n:(integer,integer) in g do if n[1]<>n[0] then exit; result:=true;
end;
begin
  foreach s:string in System.IO.File.ReadLines('words_alpha.txt') do if predicate(countChars('abc',s).Values.Pairwise,2) then println(s);
end.

