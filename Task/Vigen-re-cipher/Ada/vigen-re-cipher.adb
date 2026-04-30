WITH Ada.Text_IO, Ada.Characters.Handling;
USE Ada.Text_IO, Ada.Characters.Handling;

PROCEDURE Main IS
   SUBTYPE Alpha IS Character RANGE 'A' .. 'Z';
   TYPE Ring IS MOD (Alpha'Range_length);
   TYPE Seq IS ARRAY (Integer RANGE <>) OF Ring;

   FUNCTION "+" (S, Key : Seq) RETURN Seq IS
      R : Seq (S'Range);
   BEGIN
      FOR I IN R'Range LOOP
         R (I) := S (I) + Key (Key'First + (I - R'First) MOD Key'Length);
      END LOOP;
      RETURN R;
   END "+";

   FUNCTION "-" (S : Seq) RETURN Seq IS
      R : Seq (S'Range);
   BEGIN
      FOR I IN R'Range LOOP
         R (I) := - S (I);
      END LOOP;
      RETURN R;
   END "-";

   FUNCTION To_Seq (S : String) RETURN Seq IS
      R  : Seq (S'Range);
      I  : Integer := R'First;
   BEGIN
      FOR C OF To_Upper (S) LOOP
         IF C IN Alpha THEN
            R (I) := Ring'Mod (Alpha'Pos (C) - Alpha'Pos (Alpha'First));
            I := I + 1;
         END IF;
      END LOOP;
      RETURN R (R'First .. I - 1);
   END To_Seq;

   FUNCTION To_String (S : Seq ) RETURN String IS
      R : String (S'Range);
   BEGIN
      FOR I IN R'Range LOOP
         R (I) := Alpha'Val ( Integer (S (I)) + Alpha'Pos (Alpha'First));
      END LOOP;
      RETURN R;
   END To_String;

   Input : Seq := To_Seq (Get_Line);
   Key : Seq := To_Seq (Get_Line);
   Crypt : Seq := Input + Key;
BEGIN
   Put_Line ("Encrypted: " & To_String (Crypt));
   Put_Line ("Decrypted: " & To_String (Crypt + (-Key)));
END Main;
