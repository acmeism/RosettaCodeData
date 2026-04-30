with Ada.Text_Io;             use Ada.Text_Io;
with Iban_Code;

procedure Check_Iban is

   procedure Check(Iban : String) is
   begin
      if Iban_Code.Is_Legal(Iban) then
	 Put_Line(Iban & " is valid.");
      else
	 Put_Line(Iban & " is not valid.");
      end if;
   end Check;

begin
   Check("GB82 WEST 1234 5698 7654 32");
   Check("GB82WEST12345698765432");
   Check("gb82 west 1234 5698 7654 32");
   Check("GB82 TEST 1234 5698 7654 32");
   Check("GB82 WEST 1243 5698 7654 32");
end Check_Iban;
