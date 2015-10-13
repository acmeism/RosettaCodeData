program stddev;
uses math;
const
  n=8;
var
  arr: array[1..n] of real =(2,4,4,4,5,5,7,9);
function stddev(n: integer): real;
var
   i: integer;
   s1,s2,variance,x: real;
begin
    for i:=1 to n do
    begin
      x:=arr[i];
      s1:=s1+power(x,2);
      s2:=s2+x
    end;
    variance:=((n*s1)-(power(s2,2)))/(power(n,2));
    stddev:=sqrt(variance)
end;
var
   i: integer;
begin
    for i:=1 to n do
    begin
      writeln(i,' item=',arr[i]:2:0,' stddev=',stddev(i):18:15)
    end
end.
