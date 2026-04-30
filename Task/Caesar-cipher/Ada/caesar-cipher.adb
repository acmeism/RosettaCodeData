-- Caesar Cipher Implementation in Ada

with Ada.Text_IO; use Ada.Text_IO;

procedure Caesar is

   -- Base function to encrypt a character
   function Cipher(Char_To_Encrypt: Character; Shift: Integer; Base: Character) return Character is
      Base_Pos : constant Natural := Character'Pos(Base);
   begin
      return Character'Val((Character'Pos(Char_To_Encrypt) + Shift - Base_Pos) mod 26 + Base_Pos);
   end Cipher;

   -- Function to encrypt a character
   function Encrypt_Char(Char_To_Encrypt: Character; Shift: Integer) return Character is
   begin
      case Char_To_Encrypt is
         when 'A'..'Z' =>
            -- Encrypt uppercase letters
            return Cipher (Char_To_Encrypt, Shift, 'A');
         when 'a'..'z' =>
            -- Encrypt lowercase letters
            return Cipher (Char_To_Encrypt, Shift, 'a');
         when others =>
            -- Leave other characters unchanged
            return Char_To_Encrypt;
      end case;
   end Encrypt_Char;

   -- Function to decrypt a character
   function Decrypt_Char(Char_To_Decrypt: Character; Shift: Integer) return Character is
   begin
      return Encrypt_Char(Char_To_Decrypt, -Shift);
   end Decrypt_Char;

   Message: constant String := Ada.Text_IO.Get_Line;
   Shift: Positive := 3; -- Default key from "Commentarii de Bello Gallico" shift cipher
                         -- Shift value (can be any positive integer)

   Encrypted_Message: String(Message'Range);
   Decrypted_Message: String(Message'Range);
begin
   -- Encrypt the message
   for I in Message'Range loop
      Encrypted_Message(I) := Encrypt_Char(Message(I), Shift);
   end loop;

   -- Decrypt the encrypted message
   for I in Message'Range loop
      Decrypted_Message(I) := Decrypt_Char(Encrypted_Message(I), Shift);
   end loop;

   -- Display results
   Put_Line("Plaintext: " & Message);
   Put_Line("Ciphertext: " & Encrypted_Message);
   Put_Line("Decrypted Ciphertext: " & Decrypted_Message);

end Caesar;
