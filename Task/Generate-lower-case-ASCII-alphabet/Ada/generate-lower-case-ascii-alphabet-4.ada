-- Here is the fleshed-out code using the snippets from above
-- Note that I could have enhanced the output by not displaying the last comma
-- December 2024, R. B. E.

with Ada.Text_IO;

procedure Generate_Lower_Case_ASCII_Alphabet is

-- We start with a strong type definition: A character range that can only hold lower-case letters:

   type Lower_Case is new Character range 'a' .. 'z';

-- Now we define an array type and initialize the Array A of that type with the 26 letters:

   type Arr_Type is array (Integer range <>) of Lower_Case;
   A : Arr_Type (1 .. 26) := "abcdefghijklmnopqrstuvwxyz";

-- Strong typing would catch two errors: (1) any upper-case letters or
-- other symbols in the string assigned to A, and (2) too many or too
-- few letters assigned to A. However, a letter might still appear
-- twice (or more) in A, at the cost of one or more other
-- letters. Array B is safe even against such errors:

  B : Arr_Type (1 .. 26);
begin
  B(B'First) := 'a';
  for I in B'First .. B'Last-1 loop
    B(I+1) := Lower_Case'Succ(B(I));
  end loop; -- now all the B(I) are different
  for I in B'First .. B'Last loop
    Ada.Text_IO.Put (B(I)'Image & ", ");
  end loop;
  Ada.Text_IO.New_Line;
end Generate_Lower_Case_ASCII_Alphabet;
