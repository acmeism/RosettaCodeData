with Ada.Text_IO, Generic_Root;   use Generic_Root;

procedure Multiplicative_Root is

   procedure Compute is new Compute_Root("*"); -- "*" for multiplicative roots

   package TIO renames Ada.Text_IO;
   package NIO is new TIO.Integer_IO(Number);

   procedure Print_Numbers(Target_Root: Number; How_Many: Natural) is
      Current: Number := 0;
      Root, Pers: Number;
   begin
       for I in 1 .. How_Many loop
	  loop
	     Compute(Current, Root, Pers);
	     exit when Root = Target_Root;
	     Current := Current + 1;
	  end loop;
	  NIO.Put(Current, Width => 6);
	  if I < How_Many then
	     TIO.Put(",");
	  end if;
	  Current := Current + 1;
       end loop;
   end Print_Numbers;

   Inputs: Number_Array := (123321, 7739, 893, 899998);
   Root, Pers: Number;
begin
   TIO.Put_Line("  Number   MDR    MP");
   for I in Inputs'Range loop
       Compute(Inputs(I), Root, Pers);
       NIO.Put(Inputs(I), Width => 8);
       NIO.Put(Root, Width => 6);
       NIO.Put(Pers, Width => 6);
       TIO.New_Line;
   end loop;
   TIO.New_Line;

   TIO.Put_Line(" MDR    first_five_numbers_with_that_MDR");
   for I in 0 .. 9 loop
      TIO.Put("  " & Integer'Image(I) & "  ");
      Print_Numbers(Target_Root => Number(I), How_Many => 5);
      TIO.New_Line;
   end loop;
end Multiplicative_Root;
