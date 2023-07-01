function rule_90(ev :  String) : String;
var
   l, i	: Integer;
   cp	: String;
   s	: Array[0..1] of Boolean;
begin
   l := length(ev);
   cp := copy(ev, 1, l);
   for i := 1 to l do begin
      if (i-1) < 1 then
	 s[0] := false
      else
	 s[0] := truth(ev[i-1]);
      if (i+1) > l then
	 s[1] := false
      else
	 s[1] := truth(ev[i+1]);
      if ( (s[0] and not s[1]) or (s[1] and not s[0]) ) then
	 cp[i] := '*'
      else
	 cp[i] := ' ';
   end;
   rule_90 := cp
end;

procedure triangle(n : Integer);
var
   i, l	: Integer;
   b	: String;
begin
   l := ipow(2, n+1);
   b := ' ';
   for i := 1 to l do
      b := concat(b, ' ');
   b[round(l/2)] := '*';
   writeln(b);
   for i := 1 to (round(l/2)-1) do begin
      b := rule_90(b);
      writeln(b)
   end
end;
