package body Chi_Square is

   function Distance(Bins: Bins_Type) return Flt is
      Bad_Bins: Natural := 0;
      Sum: Natural := 0;
      Expected: Flt;
      Result: Flt;
   begin
      for I in Bins'Range loop
         if Bins(I) < 5 then
            Bad_Bins := Bad_Bins + 1;
         end if;
         Sum := Sum + Bins(I);
      end loop;
      if 5*Bad_Bins > Bins'Length then
         raise Program_Error with "too many (almost) empty bins";
      end if;

      Expected := Flt(Sum) / Flt(Bins'Length);
      Result := 0.0;
      for I in Bins'Range loop
         Result := Result + ((Flt(Bins(I)) - Expected)**2) / Expected;
      end loop;
      return Result;
   end Distance;

end Chi_Square;
