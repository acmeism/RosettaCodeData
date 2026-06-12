// Find words which contains all the vowels. Nigel Galloway: September 3rd., 2024
var predicate:Dictionary<char,integer>->boolean:=n->(n['a']=1) and (n['e']=1) and (n['i']=1) and (n['o']=1) and (n['u']=1);
begin
  foreach s:string in System.IO.File.ReadLines('unixdict.txt') do if (s.Length>10) and (predicate(countChars('aeiou',s))) then println(s);
end.

