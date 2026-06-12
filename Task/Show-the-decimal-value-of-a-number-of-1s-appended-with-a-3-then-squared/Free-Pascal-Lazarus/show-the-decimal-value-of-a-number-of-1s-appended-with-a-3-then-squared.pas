{
  10^pot+k -> prepend a 1  1113-> 11113
  (10^pot+k)^2 = 10^(2*pot)+ 2*10^pot*k + k^2
  (10^pot+k)^2 = 10^pot*(10^pot+2*k) + k^2
  s_lastsqr = k*k
  s_DeltaSqr = (10^pot+2*k) => 1222....2226
  shift s_DeltaSqr by pot digits in SumMyDeltaSqr =>  10^pot*(10^pot+2*k)
}
program OnesAppend3AndSquare;
const
  MAX = 3700;
type
  tmyNumb = array of byte;
var
  res :AnsiString;

procedure OutMyNumb(const n: tmyNUmb;l,w: integer);
var
  i,ofs : integer;
begin
  l += 1;
  if w < l then
    w := l+1;
  setlength(res,w);
  fillchar(res[1],w,' ');
  ofs := w-l;
  For i := 1 to l do
    res[i+ofs] := chr(n[l-i]+48);
  write(res);
end;

procedure Out_k_sqr(const k,sqr_k: tmyNUmb;pot:integer);
var
  dgtcnt : integer;
Begin
  write(pot:4);
  dgtcnt := 22;
  if pot > 10 then
    dgtcnt := 78;
  OutMyNumb(k,pot,dgtcnt-4);
  if pot > 10 then
    writeln;
  OutMyNumb(sqr_k,2*pot,dgtcnt);
  writeln;
end;
procedure SumMyDeltaSqr(var res:tmyNUmb;const s:tmyNumb;pot: integer);
//res = s_lastsqr
//s = s_DeltaSqr
//shift s by l => (10^pot) * s_DeltaSqr = 10^pot*(10^pot+2*k)
var
  i,sum,carry : integer;
begin
  carry := 0;
  For i := 0 to pot+1 do
  begin
    sum :=  res[i+pot]+s[i]+carry;
    carry := ord(sum>9);
    sum -= (-carry) AND 10;
    res[i+pot] := sum;
  end;
end;

var
  s,s_DeltaSqr,s_lastsqr : tmyNumb;
  pot: integer;
Begin
   setlength(s,MAX);
   setlength(s_DeltaSqr,Max+1);
   setlength(s_lastsqr,2*Max+1);
   pot := 0;
   s[pot] := 3;
   s_lastsqr[pot] := 9;
   repeat
     SumMyDeltaSqr(s_lastsqr,s_DeltaSqr,pot);
     if pot < 10 then
       Out_k_sqr(s,s_lastsqr,pot);
     if pot = 37 then
       Out_k_sqr(s,s_lastsqr,pot);

     if pot > 0 then
       s_DeltaSqr[pot]:= 2 // =>2*s[i] 2222...26
     else
       s_DeltaSqr[0] := 6;// =>2*s[0]  6
     inc(pot);
     s_DeltaSqr[pot]:= 1; //1...6
     s[pot] := 1;
   until pot = MAX;
   Writeln('Finished til ',MAX);
end.
