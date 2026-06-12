// ABC incremental counts. Nigel Galloway: August 29th., 2024
function predicate(g:Sequence of (integer,integer);m:integer):boolean;
begin
  result:=false; if g.First[0]<m then exit;
  foreach n:(integer,integer) in g do if n[1]<>n[0]+1 then exit; result:=true;
end;
var
  abc:string->Sequence of (integer,integer):=n->countChars('abc',n).Values.Sorted.Pairwise;
  the:string->Sequence of (integer,integer):=n->countChars('the',n).Values.Sorted.Pairwise;
  cio:string->Sequence of (integer,integer):=n->countChars('cio',n).Values.Sorted.Pairwise;
begin
  println('Results from unixdict.txt:');
  foreach s:string in System.IO.File.ReadLines('unixdict.txt') do
     if predicate(abc(s),1) or predicate(the(s),1) or predicate(cio(s),2) then println(s);
  println; println('Results from words_alpha.txt:');
  foreach s:string in System.IO.File.ReadLines('words_alpha.txt') do
     if predicate(abc(s),2) or predicate(the(s),2) or predicate(cio(s),3) then println(s);
end.
