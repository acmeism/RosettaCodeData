declare
   Data : Storage_Array (1..20); -- Data created
begin
   Data := (others => 0); -- Assign all zeros
   if Data = (1..10 => 0) then -- Compare with 10 zeros
      declare
         Copy : Storage_Array := Data; -- Copy Data
      begin
         if Data'Length = 0 then -- If empty
            ...
         end if;
      end;
   end if;
   ... Data & 1 ...         -- The result is Data with byte 1 appended
   ... Data & (1,2,3,4) ... -- The result is Data with bytes 1,2,3,4 appended
   ... Data (3..5) ...      -- The result the substring of Data from 3 to 5
end; -- Data destructed
