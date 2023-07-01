procedure revString(var s:string);
var
  i,j:integer;
  tmp:char;
begin
  i := 1;
  j := length(s);
  while i<j do
  begin
     tmp:=s[i];
     s[i]:=s[j];
     s[j]:=tmp;
     inc(i);
     dec(j)
  end;
end;
