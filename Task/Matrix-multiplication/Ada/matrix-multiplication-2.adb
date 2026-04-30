package Matrix_Ops is
   type Matrix is array (Natural range <>, Natural range <>) of Float;
   function "*" (Left, Right : Matrix) return Matrix;
end Matrix_Ops;

package body Matrix_Ops is
   ---------
   -- "*" --
   ---------
   function "*" (Left, Right : Matrix) return Matrix is
      Temp : Matrix(Left'Range(1), Right'Range(2)) := (others =>(others => 0.0));
   begin
      if Left'Length(2) /= Right'Length(1) then
         raise Constraint_Error;
      end if;

      for I in Left'range(1) loop
         for J in Right'range(2) loop
            for K in Left'range(2) loop
               Temp(I,J) := Temp(I,J) + Left(I, K)*Right(K, J);
            end loop;
         end loop;
      end loop;
      return Temp;
   end "*";
end Matrix_Ops;
