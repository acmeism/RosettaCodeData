with Ada.Text_IO; use Ada.Text_IO;

procedure chao_slices is
   type iMode is (Encrypt, Decrypt);

   L_Alphabet : String := "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
   R_Alphabet : String := "PTLNBQDEOYSFAVZKGJRIHWXUMC";
   plaintext  : String := "WELLDONEISBETTERTHANWELLSAID";
   ciphertext : String (1 .. plaintext'length);
   plaintext2 : String (1 .. plaintext'length);
   offset     : Natural;

   function IndexOf (Source : String; Value : Character) return Positive is
      Result : Positive;

   begin
      for I in Source'Range loop
         if Source (I) = Value then
            Result := I;
            exit;
         end if;
      end loop;
      return Result;
   end IndexOf;

   function Exec
     (Text : String; mode : iMode; showsteps : Boolean := False) return String
   is
      etext : String (Text'First .. Text'Last);
      temp  : String (1 .. 26);
      index : Positive;
      store : Character;
      left  : String := L_Alphabet;
      right : String := R_Alphabet;
   begin
      for I in Text'Range loop
         if showsteps then
            Put_Line (left & "  " & right);
         end if;

         if mode = Encrypt then
            index     := IndexOf (Source => right, Value => Text (I));
            etext (I) := left (index);
         else
            index     := IndexOf (Source => left, Value => Text (I));
            etext (I) := right (index);
         end if;

         exit when I = Text'Last;

         -- permute left
         -- The array value permutations are performed using array slices
         -- rather than explicit loops

         if index > 1 then
            offset                 := 26 - index;
            temp (1 .. offset + 1) := left (index .. index + offset);

            temp (offset + 2 .. 26) := left (1 .. index - 1);
            store                   := temp (2);

            temp (2 .. 13) := temp (3 .. 14);
            temp (14)      := store;
            left           := temp;

            -- permute right
            -- The array value permutations are performed using array slices
            -- rather than explicit loops

            temp (1 .. offset + 1) := right (index .. index + offset);

            temp (offset + 2 .. 26) := right (1 .. index - 1);
            store                   := temp (1);

            temp (1 .. 25) := temp (2 .. 26);
            temp (26)      := store;
            store          := temp (3);

            temp (3 .. 13) := temp (4 .. 14);
            temp (14)      := store;
            right          := temp;
         end if;

      end loop;

      return etext;

   end Exec;
begin
   Put_Line ("The original text is : " & plaintext);
   New_Line;
   Put_Line
     ("The left and right alphabets after each permutation during encryption are:");
   New_Line;
   ciphertext := Exec (plaintext, Encrypt, True);
   New_Line;
   Put_Line ("The ciphertext is : " & ciphertext);
   plaintext2 := Exec (ciphertext, Decrypt);
   New_Line;
   Put_Line ("The recovered plaintext is : " & plaintext2);
end chao_slices;
