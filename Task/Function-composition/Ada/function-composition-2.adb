package body Functions is
   function "*" (Left : Func; Right : Argument) return Argument is
   Result : Argument := Right;
   begin
      for I in reverse Left'Range loop
         Result := Left (I) (Result);
      end loop;
      return Result;
   end "*";

   function "*" (Left, Right : Func) return Func is
   begin
      return Left & Right;
   end "*";

   function "*" (Left : Func; Right : Primitive_Operation) return Func is
   begin
      return Left & (1 => Right);
   end "*";

   function "*" (Left, Right : Primitive_Operation) return Func is
   begin
      return (Left, Right);
   end "*";
end Functions;
