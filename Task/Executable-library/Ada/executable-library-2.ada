with Ada.Text_IO, Parameter, Hailstones;

procedure Hailstone is
   -- if Parameter.X > 0, the length of Hailstone(Parameter.X)
   -- is computed and written into Parameter.Y

   -- if Parameter.X = 0, Hailstone(27) and N <= 100_000 with maximal
   -- Hailstone(N) are computed and printed.

   procedure Show_Sequence(N: Natural) is
      Seq: Hailstones.Integer_Sequence := Hailstones.Create_Sequence(N);
   begin
      Ada.Text_IO.Put("Hailstone(" & Integer'Image(N) & " ) = (");
      if Seq'Length < 8 then
         for I in Seq'First .. Seq'Last-1 loop
            Ada.Text_IO.Put(Integer'Image(Seq(I)) & ",");
         end loop;
      else
         for I in Seq'First .. Seq'First+3 loop
            Ada.Text_IO.Put(Integer'Image(Seq(I)) & ",");
         end loop;
         Ada.Text_IO.Put(" ...,");
         for I in Seq'Last-3 .. Seq'Last-1 loop
            Ada.Text_IO.Put(Integer'Image(Seq(I)) &",");
         end loop;
      end if;
      Ada.Text_IO.Put_Line(Integer'Image(Seq(Seq'Last)) & " ); Length: " &
                             Integer'Image(seq'Length));
   end Show_Sequence;
begin
   if Parameter.X>0 then
      Parameter.Y := Hailstones.Create_Sequence(Parameter.X)'Length;
   else
      Show_Sequence(27);
      declare
         Longest: Natural := 0;
         Longest_Length: Natural := 0;
      begin
         for I in 2 .. 100_000 loop
            if Hailstones.Create_Sequence(I)'Length > Longest_Length then
               Longest := I;
               Longest_Length :=  Hailstones.Create_Sequence(I)'Length;
            end if;
         end loop;
         Ada.Text_IO.Put("Longest<=100_000: ");
         Show_Sequence(Longest);
      end;
   end if;
end Hailstone;
