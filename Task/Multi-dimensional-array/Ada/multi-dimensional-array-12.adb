function "*" (Left : Vector; Right : Integer) return Vector is
   Result : Vector;
begin
   for I in Vector'Range loop
      Result(I) := Left(I) * Right;
   end loop;
   return Result;
end "*"
