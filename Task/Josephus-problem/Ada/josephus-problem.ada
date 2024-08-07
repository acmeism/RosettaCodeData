with Ada.Command_Line, Ada.Text_IO;

procedure Josephus is

   function Arg(Index, Default: Positive) return Natural is -- read Argument(Index)
      (if Ada.Command_Line.Argument_Count >= Index
         then Natural'Value(Ada.Command_Line.Argument(Index)) else Default);

   Prisoners:  constant Positive := Arg(Index => 1, Default => 41);
   Steps:      constant Positive := Arg(Index => 2, Default =>  3);
   Survivors:  constant Positive := Arg(Index => 3, Default =>  1);
   Print:               Boolean := (Arg(Index => 4, Default =>  1) = 1);

   subtype Index_Type is Natural range 0 .. Prisoners-1;
   Next: array(Index_Type) of Index_Type;
   X: Index_Type := (Steps-2) mod Prisoners;

begin
   Ada.Text_IO.Put_Line
     ("N =" & Positive'Image(Prisoners) & ",  K =" & Positive'Image(Steps) &
        (if Survivors > 1 then ",  #survivors =" & Positive'Image(Survivors)
        else ""));
   for Index in Next'Range loop -- initialize Next
      Next(Index) := (Index+1) mod Prisoners;
   end loop;
   if Print then
      Ada.Text_IO.Put("Executed: ");
   end if;
   for Execution in reverse 1 .. Prisoners loop
      if Execution = Survivors then
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put("Surviving: ");
         Print := True;
      end if;
      if Print then
         Ada.Text_IO.Put(Positive'Image(Next(X)));
      end if;
      Next(X) := Next(Next(X)); -- "delete" a prisoner
      for Prisoner in 1 .. Steps-1 loop
         X := Next(X);
      end loop;
   end loop;
end Josephus;
