program Palindro;

{ RECURSIVE }
function is_palindro_r(s : String) : Boolean;
begin
   if length(s) <= 1 then
      is_palindro_r := true
   else begin
      if s[1] = s[length(s)] then
	 is_palindro_r := is_palindro_r(copy(s, 2, length(s)-2))
      else
	 is_palindro_r := false
   end
end; { is_palindro_r }

{ NON RECURSIVE; see [[Reversing a string]] for "reverse" }
function is_palindro(s : String) : Boolean;
begin
   if s = reverse(s) then
      is_palindro := true
   else
      is_palindro := false
end;
