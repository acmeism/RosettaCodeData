// Modular exponentiation. Nigel Galloway:August 22nd., 2024
type I=System.Numerics.BigInteger;
var bi:string->I:=n->I.Parse(n);
function expMod(a:I;b:I;n:I):I;
  function fN(a:I;b:I;c:I):I;
  begin
    result:=if b=0 then c else fN(a*(a mod n),b/bi('2'),(if (b mod 2)=0 then c else c*a mod n));
  end;
begin
  result:=fN(a,b,I.One)
end;
begin
  var a := bi('2988348162058574136915891421498819466320163312926952423791023078876139');
  var b := bi('2351399303373464486466122544523690094744975233415544072992656881240319');
  println(expMod(a,b,bi('10')**40).ToString());
end.
