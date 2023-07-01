with Ada.Text_IO, Ada.Command_Line, Chi_Square; use Ada.Text_IO;

procedure Test_Chi_Square is

   package Ch2 renames Chi_Square; use Ch2;
   package FIO is new Float_IO(Flt);

   B: Bins_Type(1 .. Ada.Command_Line.Argument_Count);
   Bound_For_5_Per_Cent: constant array(Positive range <>) of Flt :=
     ( 1 => 3.84,   2 =>  5.99,  3 =>  7.82,  4 => 9.49,   5 =>  11.07,
       6 => 12.59,  7 => 14.07,  8 => 15.51,  9 => 16.92, 10 =>  18.31);
     -- picked from http://en.wikipedia.org/wiki/Chi-squared_distribution

   Dist: Flt;

begin
   for I in B'Range loop
      B(I) := Natural'Value(Ada.Command_Line.Argument(I));
   end loop;
   Dist := Distance(B);
   Put("Degrees of Freedom:" & Integer'Image(B'Length-1) & ", Distance: ");
   FIO.Put(Dist, Fore => 6, Aft => 2, Exp => 0);
   if Dist <= Bound_For_5_Per_Cent(B'Length-1) then
      Put_Line("; (apparently uniform)");
   else
      Put_Line("; (deviates significantly from uniform)");
   end if;
end;
