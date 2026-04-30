function "-" (Left, Right : Luminance) return Count is
begin
   if Left > Right then
      return Count (Left) - Count (Right);
   else
      return Count (Right) - Count (Left);
   end if;
end "-";
