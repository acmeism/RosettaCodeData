// Find words which contains more than 3 e vowels . Nigel Galloway: August 28th., 2024
function countChars(n:Sequence of char;g:string):Dictionary<char,integer>;
begin
  result:=Dict(n.Zip(SeqFill(maxInt,0),(n,g) -> (n,g)));
  foreach c:char in g do if result.ContainsKey(c) then result[c]+=1;
end;
var predicate:Dictionary<char,integer>->boolean:=n->(n['e']>3) and (n['a']+n['i']+n['o']+n['u']=0);
begin
  foreach s:string in System.IO.File.ReadLines('unixdict.txt') do if predicate(countChars('aeiou',s)) then println(s);
end.
