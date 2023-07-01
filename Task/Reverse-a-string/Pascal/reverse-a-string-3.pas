function reverse(s:string):string;
var i:integer;
var tmp:char;
begin
    for i:=1 to length(s) div 2 do
      begin
       tmp:=s[i];
       s[i]:=s[length(s)+1-i];
       s[length(s)+1-i]:=tmp;
       reverse:=s;
      end;
end;
