function Max (Left, Right : Integer) return Integer is
begin
   if Left < Right then
      return Right;
   else
      return Left;
   end if;
end Max;
