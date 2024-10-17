// I before E except after C. Nigel Galloway: September 30th., 2024
type plausibility=(plausible,implausible);
var fN:string->string->integer:=n->g->System.Text.RegularExpressions.Regex.Matches(n,g).count;
var fG:Func<string,integer>->(array of integer)->array of integer:=n->g->g.Zip(|n('ie'),n('ei'),n('cie'),n('cei')|,(n,g)->n+g).ToArray;
begin
  var n:=System.IO.File.ReadLines('unixdict.txt').Aggregate(|0,0,0,0|,(n,g)->fG(fN(g))(n));
  println($'I before E except after C is {if n[0]-n[2]>2*n[2] then plausible else implausible}');
  println($'E before I except after C is {if n[1]-n[3]>2*n[3] then plausible else implausible}');
  println($'I before E   when after C is {if n[2]>2*n[3] then plausible else implausible}');
  println($'E before I   when after C is {if n[3]>2*n[2] then plausible else implausible}');
end.
