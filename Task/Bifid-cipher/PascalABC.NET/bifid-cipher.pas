// Bifid cipher. Nigel Galloway: September 18th., 2024
function polybius(alphabet:string;n,g:integer):(Dictionary<char,(integer,integer)>,Dictionary<(integer,integer),char>);
begin
  var ng:=Cartesian(1..n,1..g);
  Result:=(Dict(Zip(alphabet,ng)),Dict(Zip(ng,alphabet)));
end;
function fN(e:Dictionary<char,(integer,integer)>;n:string):(sequence of integer,sequence of integer):=(n.Substring(1).Scan(e[n[1]],(n,g)->e[g])).UnZipTuple;
function encrypt(e:(Dictionary<char,(integer,integer)>,Dictionary<(integer,integer),char>);text:string):string;
begin
  var fG:((sequence of integer,sequence of integer),Dictionary<(integer,integer),char>)->string:=(n,e)->(n[0]+n[1]).Batch(2).Aggregate('',(n,g)->n+e[(g[0],g[1])]);
  Result:=fG(fN(e[0],text),e[1]);
end;
function decrypt(e:(Dictionary<char,(integer,integer)>,Dictionary<(integer,integer),char>);text:string):string;
begin
  var fG:(sequence of (integer,integer),Dictionary<(integer,integer),char>)->string:=(n,e)->n.Aggregate('',(n,g)->n+e[(g[0],g[1])]);
  var t:=fN(e[0],text); var z:=t[0].Interleave(t[1]).SplitAt(t[0].count);
  Result:=fG(z[0].ZipTuple(z[1]),e[1]);
end;
begin
  var p:=polybius('abcdefghiklmnopqrstuvwxyz',5,5); var s,e:string;
  s:='fleeatonce'; e:=encrypt(p,s); println($'{s} -> {e} -> {decrypt(p,e)}');
  s:='attackatdawn'; e:=encrypt(p,s); println($'{s} -> {e} -> {decrypt(p,e)}');
  p:=polybius('bgwkzqpndsioaxefclumthyvr',5,5);
  e:=encrypt(p,s); println($'{s} -> {e} -> {decrypt(p,e)}');
  s:='fleeatonce'; e:=encrypt(p,s); println($'{s} -> {e} -> {decrypt(p,e)}');
  p:=polybius('abcdefghijklmnopqrstuvwxyz0123456789',6,6);
  s:='theinvasionwillstarton1january2025'; e:=encrypt(p,s); println($'{s} -> {e} -> {decrypt(p,e)}');
end.
