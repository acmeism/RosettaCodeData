with Prime_Numbers, Ada.Text_IO;

procedure Test_Prime is

   package Integer_Numbers is new
     Prime_Numbers (Natural, 0, 1, 2);
   use Integer_Numbers;

   procedure Put (List : Number_List) is
   begin
      for Index in List'Range loop
         Ada.Text_IO.Put (Positive'Image (List (Index)));
      end loop;
   end Put;

begin
   Put (Decompose (12));
end Test_Prime;
