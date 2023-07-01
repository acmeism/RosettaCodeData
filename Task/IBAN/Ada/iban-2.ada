with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Containers.Hashed_Maps;
with Ada.Strings.Hash;

package body Iban_Code is

   subtype Nation is String (1..2);

   package String_Integer is new Ada.Containers.Hashed_Maps
     (Nation, Integer, Ada.Strings.Hash, Equivalent_Keys => "=");

   Nations : String_Integer.Map;

   function Is_Legal(Iban : String) return Boolean
   is
      Temp  : String(Iban'Range) := (others => ' ');
      Count : Integer;
      Ch    : Character;
      Num   : Integer := 0;
   begin
      -- remove blank spaces and check characters
      Count := Temp'First;
      for I in Iban'Range loop
	 case Iban(I) is
	    when ' ' => null;
	    when 'a'..'z' =>
	       Temp(Count) := To_Upper(Iban(I));
	       Count := Count + 1;
	    when 'A'..'Z'|'0'..'9' =>
	       Temp(Count) := Iban(I);
	       Count := Count + 1;
	    when others => return False;
	 end case;
      end loop;
      -- check nation code and length
      if not Nations.Contains (Temp(1..2)) or else
	Nations.Element (Temp(1..2))/= Count - 1 then
	 return False;
      end if;
      -- move the 4 initial characters to the end
      Temp(Temp'First..Count-1) := Temp(5..Count-1) & Temp(Temp'First..4);
      -- compute remainder modulo 97
      for I in Temp'First..Count-1 loop
	 Ch := Temp(I);
	 if Ch in '0'..'9' then
	    Num := Integer'Value(Integer'Image(Num) & Ch) mod 97;
	 else
	    Num := (Num * 100 +
		      (Character'Pos(Ch) - Character'Pos('A') + 10)) mod 97;
	 end if;
      end loop;
      return Num = 1;
   end Is_Legal;

begin
   Nations.insert("AL", 28);     Nations.insert("AD", 24);
   Nations.insert("AT", 20);     Nations.insert("AZ", 28);
   Nations.insert("BE", 16);     Nations.insert("BH", 22);
   Nations.insert("BA", 20);     Nations.insert("BR", 29);
   Nations.insert("BG", 22);     Nations.insert("CR", 21);
   Nations.insert("HR", 21);     Nations.insert("CY", 28);
   Nations.insert("CZ", 24);     Nations.insert("DK", 18);
   Nations.insert("DO", 28);     Nations.insert("EE", 20);
   Nations.insert("FO", 18);     Nations.insert("FI", 18);
   Nations.insert("FR", 27);     Nations.insert("GE", 22);
   Nations.insert("DE", 22);     Nations.insert("GI", 23);
   Nations.insert("GR", 27);     Nations.insert("GL", 18);
   Nations.insert("GT", 28);     Nations.insert("HU", 28);
   Nations.insert("IS", 26);     Nations.insert("IE", 22);
   Nations.insert("IL", 23);     Nations.insert("IT", 27);
   Nations.insert("KZ", 20);     Nations.insert("KW", 30);
   Nations.insert("LV", 21);     Nations.insert("LB", 28);
   Nations.insert("LI", 21);     Nations.insert("LT", 20);
   Nations.insert("LU", 20);     Nations.insert("MK", 19);
   Nations.insert("MT", 31);     Nations.insert("MR", 27);
   Nations.insert("MU", 30);     Nations.insert("MC", 27);
   Nations.insert("MD", 24);     Nations.insert("ME", 22);
   Nations.insert("NL", 18);     Nations.insert("NO", 15);
   Nations.insert("PK", 24);     Nations.insert("PS", 29);
   Nations.insert("PL", 28);     Nations.insert("PT", 25);
   Nations.insert("RO", 24);     Nations.insert("SM", 27);
   Nations.insert("SA", 24);     Nations.insert("RS", 22);
   Nations.insert("SK", 24);     Nations.insert("SI", 19);
   Nations.insert("ES", 24);     Nations.insert("SE", 24);
   Nations.insert("CH", 21);     Nations.insert("TN", 24);
   Nations.insert("TR", 26);     Nations.insert("AE", 23);
   Nations.insert("GB", 22);     Nations.insert("VG", 24);
end Iban_Code;
