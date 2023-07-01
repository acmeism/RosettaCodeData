with Ada.Text_IO;

procedure Caesar is

   type modulo26 is modulo 26;

   function modulo26 (Character: Character; Output: Character) return modulo26 is
   begin
      return modulo26 (Character'Pos(Character)+Character'Pos(Output));
   end modulo26;

   function Character(Val: in  modulo26; Output: Character)
                        return Character is
   begin
      return Character'Val(Integer(Val)+Character'Pos(Output));
   end Character;

   function crypt (Playn: String; Key: modulo26) return String is
      Ciph: String(Playn'Range);

   begin
      for I in Playn'Range loop
         case Playn(I) is
            when 'A' .. 'Z' =>
               Ciph(I) := Character(modulo26(Playn(I)+Key), 'A');
            when 'a' .. 'z' =>
               Ciph(I) := Character(modulo26(Playn(I)+Key), 'a');
            when others =>
               Ciph(I) := Playn(I);
         end case;
      end loop;
      return Ciph;
   end crypt;

   Text:  String := Ada.Text_IO.Get_Line;
   Key: modulo26 := 3; -- Default key from "Commentarii de Bello Gallico" shift cipher

begin -- encryption main program

   Ada.Text_IO.Put_Line("Playn ------------>" & Text);
   Text := crypt(Text, Key);
   Ada.Text_IO.Put_Line("Ciphertext ----------->" & Text);
   Ada.Text_IO.Put_Line("Decrypted Ciphertext ->" & crypt(Text, -Key));

end Caesar;
