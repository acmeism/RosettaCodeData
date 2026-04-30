with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use Gnat.Sockets;
procedure DNSQuerying is
   procedure Print_Address_Info (Host, Serv : String; Family : Family_Type := Family_Unspec) is
      Addresses : Address_Info_Array := Get_Address_Info (Host, Serv, Family, Passive => False, Numeric_Host => False);
      Inet_Addr_V6: Inet_Addr_Type(Family_Inet6);
   begin
      Sort (Addresses, IPv6_TCP_Preferred'Access);
      Inet_Addr_V6 := Addresses(1).Addr.Addr;
      Put_Line("IPv6: " & Image(Value => Inet_Addr_V6));
   end Print_Address_Info;
begin
   Print_Address_Info ("ipv6.google.com", "https", Family_Inet6);
end DNSQuerying;
