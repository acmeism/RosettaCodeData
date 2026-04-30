with Prime_Numbers;

procedure Test_Prime is

   package Integer_Numbers is new
     Prime_Numbers (Natural, 0, 1, 2);
   use Integer_Numbers;

begin
   if Is_Prime(12) or (not Is_Prime(13)) then
      raise Program_Error with "Test_Prime failed!";
   end if;
end Test_Prime;
