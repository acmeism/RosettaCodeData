with Ada.Text_IO;
with Prime_Numbers;
procedure Parallel is
   package Integer_Primes is new Prime_Numbers (
      Number => Integer, -- use Large_Integer for longer numbers
      Zero   => 0,
      One    => 1,
      Two    => 2,
      Image  => Integer'Image);

   My_List : Integer_Primes.Number_List :=
     ( 12757923,
       12878611,
       12757923,
       15808973,
       15780709,
      197622519);

   Decomposers : array (My_List'Range) of Integer_Primes.Calculate_Factors;
   Lengths     : array (My_List'Range) of Natural;
   Max_Length  : Natural := 0;
begin
   for I in My_List'Range loop
      -- starts the tasks
      Decomposers (I).Start (My_List (I));
   end loop;
   for I in My_List'Range loop
      -- wait until task has reached Get_Size entry
      Decomposers (I).Get_Size (Lengths (I));
      if Lengths (I) > Max_Length then
         Max_Length := Lengths (I);
      end if;
   end loop;
   declare
      Results                :
        array (My_List'Range) of Integer_Primes.Number_List (1 .. Max_Length);
      Largest_Minimal_Factor : Integer := 0;
      Winning_Index          : Positive;
   begin
      for I in My_List'Range loop
         -- after Get_Result, the tasks terminate
         Decomposers (I).Get_Result (Results (I));
         if Results (I) (1) > Largest_Minimal_Factor then
            Largest_Minimal_Factor := Results (I) (1);
            Winning_Index          := I;
         end if;
      end loop;
      Ada.Text_IO.Put_Line
        ("Number" & Integer'Image (My_List (Winning_Index)) &
         " has largest minimal factor:");
      Integer_Primes.Put (Results (Winning_Index) (1 .. Lengths (Winning_Index)));
      Ada.Text_IO.New_Line;
   end;
end Parallel;
