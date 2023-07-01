package body Logic is

   function Sum(T: Table) return Natural is
      Result: Natural := 0;
   begin
      for I in T'Range loop
         if T(I) then
            Result := Result + 1;
         end if;
      end loop;
      return Result;
   end Sum;

   function Half(T: Table; Which: Even_Odd) return Table is
      Result: Table(T'Range);
      Last: Natural := Result'First - 1;
   begin
      for I in T'Range loop
         if I mod 2 = (if (Which=Odd) then 1 else 0) then
            Last := Last+1;
            Result(Last) := T(I);
         end if;
      end loop;
      return Result(Result'First .. Last);
   end Half;

end Logic;
