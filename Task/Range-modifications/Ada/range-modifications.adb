with Ada.Text_IO;            use Ada.Text_IO;
with Strings_Edit.Integers;  use Strings_Edit.Integers;

with Generic_Discrete_Set;

procedure Range_Modifications is
   package Integer_Set is new Generic_Discrete_Set (Integer);
   use Integer_Set;

   procedure Print (S : Set) is
      From, To : Integer;
   begin
      for I in 1..S.Get_Size loop
         S.Get (I, From, To);
         if I > 1 then
            Put (", ");
         end if;
         if From = To then
            Put (Image (From));
         else
            Put (Image (From) & ".." & Image (To));
         end if;
      end loop;
      New_Line;
   end Print;

   S : Set;
begin
   Put_Line ("example 0");

   S.Add    (77); Put ("   add 77 => "); Print (S);
   S.Add    (79); Put ("   add 79 => "); Print (S);
   S.Add    (78); Put ("   add 78 => "); Print (S);
   S.Remove (77); Put ("remove 77 => "); Print (S);
   S.Remove (78); Put ("remove 78 => "); Print (S);
   S.Remove (79); Put ("remove 79 => "); Print (S);

   Put_Line ("example 1");
   S.Add (1, 3); S.Add (5);

   S.Add    (1);  Put ("   add  1 => "); Print (S);
   S.Remove (4);  Put ("remove  4 => "); Print (S);
   S.Add    (7);  Put ("   add  7 => "); Print (S);
   S.Add    (8);  Put ("   add  8 => "); Print (S);
   S.Add    (6);  Put ("   add  6 => "); Print (S);
   S.Remove (7);  Put ("remove  7 => "); Print (S);

   Put_Line ("example 3");
   S.Erase; S.Add (1, 5); S.Add (10, 25);  S.Add (27, 30);

   S.Add    (26); Put ("   add 26 => "); Print (S);
   S.Add    ( 9); Put ("   add  9 => "); Print (S);
   S.Add    ( 7); Put ("   add  7 => "); Print (S);
   S.Remove (26); Put ("remove 26 => "); Print (S);
   S.Remove ( 9); Put ("remove  9 => "); Print (S);
   S.Remove ( 7); Put ("remove  7 => "); Print (S);

end Range_Modifications;
