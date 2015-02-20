with Prime_Numbers, Ada.Text_IO, Ada.Command_Line;

procedure Sequence_Of_Primes is

   package Integer_Numbers is new
     Prime_Numbers (Natural, 0, 1, 2);
   use Integer_Numbers;

   Start: Natural := Natural'Value(Ada.Command_Line.Argument(1));
   Stop:  Natural := Natural'Value(Ada.Command_Line.Argument(2));

begin
   for I in Start .. Stop loop
      if Is_Prime(I) then
         Ada.Text_IO.Put(Natural'Image(I));
      end if;
   end loop;
end Sequence_Of_Primes;
