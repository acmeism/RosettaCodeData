-- Bifid cipher
-- J. Carter     2023 May
-- The Bifid cipher is included as part of the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with PragmARC.Encryption.Bifid;

procedure Bifid_Test is
   package Bifid renames PragmARC.Encryption.Bifid;

   Key_1 : constant Bifid.Square_Layout := ("ABCDE", "FGHIK", "LMNOP", "QRSTU", "VWXYZ");
   Key_2 : constant Bifid.Square_Layout := ("BGWKZ", "QPNDS", "IOAXE", "FCLUM", "THYVR");

   Msg_1 : constant String := "ATTACKATDAWN";
   Msg_2 : constant String := "FLEEATONCE";
   Msg_3 : constant String := "THEINVASIONWILLSTARTONTHEFIRSTOFJANUARY";

   Crypt_1 : String (Msg_1'Range);
   Crypt_2 : String (Msg_2'Range);
   Crypt_3 : String (Msg_3'Range);
begin -- Bifid_Test
   Crypt_1 := Bifid.Encrypt (Msg_1, Key_1);
   Ada.Text_IO.Put_Line (Item => Msg_1 & " => " & Crypt_1 & " => " & Bifid.Decrypt (Crypt_1, Key_1) );
   Crypt_2 := Bifid.Encrypt (Msg_2, Key_2);
   Ada.Text_IO.Put_Line (Item => Msg_2 & " => " & Crypt_2 & " => " & Bifid.Decrypt (Crypt_2, Key_2) );
   Crypt_1 := Bifid.Encrypt (Msg_1, Key_2);
   Ada.Text_IO.Put_Line (Item => Msg_1 & " => " & Crypt_1 & " => " & Bifid.Decrypt (Crypt_1, Key_2) );
   Crypt_3 := Bifid.Encrypt (Msg_3, Key_2);
   Ada.Text_IO.Put_Line (Item => Msg_3 & " => " & Crypt_3 & " => " & Bifid.Decrypt (Crypt_3, Key_2) );
end Bifid_Test;
