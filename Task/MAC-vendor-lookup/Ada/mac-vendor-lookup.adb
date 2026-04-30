with Ada.Text_IO;

with AWS.Client;
with AWS.Response;
with AWS.Messages;

procedure MAC_Vendor is

   procedure Lookup (MAC : in String) is
      use AWS.Response;
      use AWS.Messages;
      URL     : constant String := "http://api.macvendors.com/" & MAC;
      Page    : constant Data   := AWS.Client.Get (URL);
      use Ada.Text_IO;
   begin
      Put (MAC);
      Set_Col (20);
      case AWS.Response.Status_Code (Page) is
         when S200   => Put_Line (Message_Body (Page));
         when S404   => Put_Line ("N/A");
         when others => Put_Line ("Error");
      end case;
   end Lookup;

begin
   --  Have to throttle traffic to site
   Lookup ("88:53:2E:67:07:BE");   delay 1.500;
   Lookup ("D4:F4:6F:C9:EF:8D");   delay 1.500;
   Lookup ("FC:FB:FB:01:FA:21");   delay 1.500;
   Lookup ("4c:72:b9:56:fe:bc");   delay 1.500;
   Lookup ("00-14-22-01-23-45");   delay 1.500;
   Lookup ("23-45-67");            delay 1.500;
   Lookup ("foobar");
end MAC_Vendor;
