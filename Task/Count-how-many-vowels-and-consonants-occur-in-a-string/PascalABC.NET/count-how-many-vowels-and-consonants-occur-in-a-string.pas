// Count how many vowels and consonants occur in a string. Nigel Galloway: September 2nd., 2024
type Ctype = (Vowel,Consonant,Other);
function countCtype(n:string):Dictionary<Ctype,integer>;
begin
  var r:=countChars(Lst('a'..'z'),n.ToLower);
  var vowels:=r['a']+r['e']+r['i']+r['o']+r['u'];
  var consonants:=r.Values.Sum-vowels;
  result:=Dict(Lst((Vowel,vowels),(Consonant,consonants),(Other,n.Length-vowels-consonants)));
end;
begin
  println(countCtype('Now is the time for all good men to come to the aid of their country.'));
end.

