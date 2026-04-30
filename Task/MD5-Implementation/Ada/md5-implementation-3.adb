with Ada.Strings.Unbounded;
with Ada.Text_IO;
with MD5;

procedure Tester is
   use Ada.Strings.Unbounded;
   type String_Array is array (Positive range <>) of Unbounded_String;
   Sources : constant String_Array :=
     (To_Unbounded_String (""),
      To_Unbounded_String ("a"),
      To_Unbounded_String ("abc"),
      To_Unbounded_String ("message digest"),
      To_Unbounded_String ("abcdefghijklmnopqrstuvwxyz"),
      To_Unbounded_String
         ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"),
      To_Unbounded_String
         ("12345678901234567890123456789012345678901234567890123456789012345678901234567890")
     );
   Digests : constant String_Array :=
     (To_Unbounded_String ("0xd41d8cd98f00b204e9800998ecf8427e"),
      To_Unbounded_String ("0x0cc175b9c0f1b6a831c399e269772661"),
      To_Unbounded_String ("0x900150983cd24fb0d6963f7d28e17f72"),
      To_Unbounded_String ("0xf96b697d7cb7938d525a2f31aaf161d0"),
      To_Unbounded_String ("0xc3fcd3d76192e4007dfb496cca67e13b"),
      To_Unbounded_String ("0xd174ab98d277d9f5a5611c2c9f419d9f"),
      To_Unbounded_String ("0x57edf4a22be3c955ac49da2e2107b67a"));
begin
   for I in Sources'Range loop
      Ada.Text_IO.Put_Line ("MD5 (""" & To_String (Sources (I)) & """):");
      Ada.Text_IO.Put_Line
        (MD5.To_String (MD5.MD5 (To_String (Sources (I)))));
      Ada.Text_IO.Put_Line (To_String (Digests (I)) & " (correct value)");
   end loop;
end Tester;
