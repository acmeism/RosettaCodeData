WITH GMP, GMP.Integers, Ada.Text_IO, GMP.Integers.Aliased_Internal_Value, Interfaces.C;
USE GMP, Gmp.Integers, Ada.Text_IO, Interfaces.C;

PROCEDURE Main IS
   FUNCTION "+" (U : Unbounded_Integer) RETURN Mpz_T IS (Aliased_Internal_Value (U));
   FUNCTION "+" (S : String) RETURN Unbounded_Integer IS (To_Unbounded_Integer (S));
   FUNCTION Image_Cleared (M : Mpz_T) RETURN String IS (Image (To_Unbounded_Integer (M)));
   N                 : Unbounded_Integer := +"9516311845790656153499716760847001433441357";
   E                 : Unbounded_Integer := +"65537";
   D                 : Unbounded_Integer := +"5617843187844953170308463622230283376298685";
   Plain_Text        : CONSTANT String := "Rosetta Code";
   M, M_C, M_D       : Mpz_T;
-- We import two C functions from the GMP library which are not in the specs of the gmp package
   PROCEDURE Mpz_Import
     (Rop   : Mpz_T; Count : Size_T; Order : Int; Size : Size_T; Endian : Int;
      Nails : Size_T; Op : Char_Array);
   PRAGMA Import (C, Mpz_Import, "__gmpz_import");

   PROCEDURE Mpz_Export
     (Rop    : OUT Char_Array; Count : ACCESS Size_T; Order : Int; Size : Size_T;
      Endian : Int; Nails : Size_T; Op : Mpz_T);
   PRAGMA Import (C, Mpz_Export, "__gmpz_export");
BEGIN
   Mpz_Init (M);
   Mpz_Init (M_C);
   Mpz_Init (M_D);
   Mpz_Import (M, Plain_Text'Length + 1, 1, 1, 0, 0, To_C (Plain_Text));
   Mpz_Powm (M_C, M, +E, +N);
   Mpz_Powm (M_D, M_C, +D, +N);
   Put_Line ("Encoded plain text: " & Image_Cleared (M));
   DECLARE Decrypted : Char_Array (1 .. Mpz_Sizeinbase (M_C, 256));
   BEGIN
      Put_Line ("Encryption of this encoding: " & Image_Cleared (M_C));
      Mpz_Export (Decrypted, NULL, 1, 1, 0, 0, M_D);
      Put_Line ("Decryption of the encoding: " & Image_Cleared (M_D));
      Put_Line ("Final decryption: " &  To_Ada (Decrypted));
   END;
END Main;
