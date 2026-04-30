with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.UTF_Encoding.Wide_Wide_Strings;
with Ada.Integer_Text_IO;
with Ada.Text_IO;
with Ada.Wide_Wide_Text_IO;

procedure UTF8_Encode_And_Decode
is
   package TIO renames Ada.Text_IO;
   package WWTIO renames Ada.Wide_Wide_Text_IO;
   package WWS renames Ada.Strings.UTF_Encoding.Wide_Wide_Strings;

   function To_Hex
     (i : in Integer;
      width : in Natural := 0;
      fill : in Character := '0') return String
   is
      holder : String(1 .. 20);
   begin
      Ada.Integer_Text_IO.Put(holder, i, 16);
      declare
         hex : constant String := holder(Index(holder, "#")+1 .. holder'Last-1);
         filled : String := Natural'Max(width, hex'Length) * fill;
      begin
         filled(filled'Last - hex'Length + 1 .. filled'Last) := hex;
         return filled;
      end;
   end To_Hex;

   input : constant Wide_Wide_String := "AöЖ€𝄞";
begin
   TIO.Put_Line("Character   Unicode    UTF-8 encoding (hex)");
   TIO.Put_Line(43 * '-');
   for WWC of input loop
      WWTIO.Put(WWC & "           ");
      declare
         filled : String := 11 * ' ';
         unicode : constant String := "U+" & To_Hex(Wide_Wide_Character'Pos(WWC), width => 4);
         utf8_string : constant String := WWS.Encode((1 => WWC));
      begin
         filled(filled'First .. filled'First + unicode'Length - 1) := unicode;
         TIO.Put(filled);
         for C of utf8_string loop
            TIO.Put(To_Hex(Character'Pos(C)) & " ");
         end loop;
         TIO.New_Line;
      end;
   end loop;
end UTF8_Encode_And_Decode;
