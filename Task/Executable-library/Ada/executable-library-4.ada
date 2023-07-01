with Hailstone, Parameter, Ada.Text_IO;

procedure Hailstone_Test is
   Counts: array (1 .. 100_000) of Natural := (others => 0);
   Max_Count: Natural := 0;
   Most_Common: Positive := Counts'First;
   Length: Natural renames Parameter.Y;
   Sample: Natural := 0;
begin
   for I in Counts'Range loop
      Parameter.X := I;
      Hailstone; -- compute the length of Hailstone(I)
      Counts(Length) := Counts(Length)+1;
   end loop;
   for I in Counts'Range loop
      if Counts(I) > Max_Count then
         Max_Count := Counts(I);
         Most_Common := I;
      end if;
   end loop;
   Ada.Text_IO.Put_Line("Most frequent length:"
                          & Integer'Image(Most_Common)
                          & ";" & Integer'Image(Max_Count)
                          & " sequences of that length.");
   for I in Counts'Range loop
       Parameter.X := I;
       Hailstone; -- compute the length of Hailstone(I)
       if Length = Most_Common then
          Sample := I;
          exit;
       end if;
   end loop;
   Ada.Text_IO.Put_Line("The first such sequence: Hailstone("
                          & Integer'Image(Sample) & " ).");
end Hailstone_Test;
