function Generic_Max (List : Items_Array) return Item is
   Result : Item := List (List'First);
begin
   for Index in List'First + 1..List'Last loop
      Result := Item'Max (Result, List (Index));
   end loop;
   return Result;
end Generic_Max;
