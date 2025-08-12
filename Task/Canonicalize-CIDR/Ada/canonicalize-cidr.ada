with Ada.Strings;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Text_IO;

use Ada.Strings;
use Ada.Strings.Fixed;
use Ada.Strings.Maps;
use Ada.Text_IO;

procedure Canonicalize_CIDR is
   type IP_Octet_Type is mod 256;

   type IP_Record_Type is record
      A, B, C, D : IP_Octet_Type;
   end record
     with Size => 32;

   for IP_Record_Type use record
      --  Use little-endian ordering to match bit array
      D at 0 range 0 .. 7;
      C at 1 range 0 .. 7;
      B at 2 range 0 .. 7;
      A at 3 range 0 .. 7;
   end record;

   type IP_Bitarray_Type is array (0 .. 31) of Boolean
     with Component_Size => 1;

   subtype IP_Mask_Type is Natural range 0 .. 32;

   type IP_CIDR_Type is record
      IP : IP_Record_Type;
      Mask : IP_Mask_Type;
   end record;

   function Parse_IP_CIDR (S : String) return IP_CIDR_Type is
      IP_Record : IP_CIDR_Type;
      Digit_Range : Character_Range := ('0', '9');
      Digit_Set : Character_Set := To_Set (Digit_Range);
      Octets : array (1 .. 4) of IP_Octet_Type;
      First : Positive;
      Last : Natural := 0;
   begin
      for I in Octets'Range loop
         Find_Token (S, Digit_Set, Last + 1, Inside, First, Last);
         Octets (I) := IP_Octet_Type'Value (S (First .. Last));
      end loop;
      IP_Record.IP.A := Octets (1);
      IP_Record.IP.B := Octets (2);
      IP_Record.IP.C := Octets (3);
      IP_Record.IP.D := Octets (4);

      Find_Token (S, Digit_Set, Last + 1, Inside, First, Last);
      IP_Record.Mask := IP_Mask_Type'Value (S (First .. Last));

      return IP_Record;
   end Parse_IP_CIDR;

   procedure Canonicalize_IP_CIDR (Addr : in out IP_CIDR_Type) is
      --  Fun part. I can overlay different types over the same bits.
      Bit_Overlay : IP_Bitarray_Type with Address => Addr.IP'Address;
   begin
      for I in Bit_Overlay'First .. Bit_Overlay'Last - Addr.Mask loop
            Bit_Overlay (I) := False;
      end loop;
   end Canonicalize_IP_CIDR;

   procedure Put_IP_CIDR (Addr : IP_CIDR_TYPE) is
      package Octet_IO is new Ada.Text_IO.Modular_IO (IP_Octet_Type);
      package Mask_IO is new Ada.Text_IO.Integer_IO (IP_Mask_Type);
   begin
      Octet_IO.Put (Addr.IP.A, 0);
      Put (".");
      Octet_IO.Put (Addr.IP.B, 0);
      Put (".");
      Octet_IO.Put (Addr.IP.C, 0);
      Put (".");
      Octet_IO.Put (Addr.IP.D, 0);
      Put ("/");
      Mask_IO.Put (Addr.Mask, 0);
   end Put_IP_CIDR;

   procedure Show_IP_Canonicalize (S : String) is
      Canon : IP_CIDR_Type := Parse_IP_CIDR (S);
   begin
      Canonicalize_IP_Cidr (Canon);
      Put (S & " -> ");
      Put_IP_CIDR (Canon);
      New_Line;
   end Show_IP_Canonicalize;

   Test_IPs : array (1 .. 5) of String (1 .. 18) :=
     (
       "36.18.154.103/12  ",
       "62.62.197.11/29   ",
       "67.137.119.181/4  ",
       "161.214.74.21/24  ",
       "184.232.176.184/18"
     );
begin
   for I of Test_IPs loop
      Show_IP_Canonicalize (I);
   end loop;
end Canonicalize_CIDR;
