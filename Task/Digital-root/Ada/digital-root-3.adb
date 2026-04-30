with Generic_Root, Ada.Text_IO; use Generic_Root;

procedure Digital_Root is

   procedure Compute is new Compute_Root("+");
     -- "+" for additive digital roots

   package TIO renames Ada.Text_IO;

    procedure Print_Roots(Inputs: Number_Array; Base: Base_Type) is
      package NIO is new TIO.Integer_IO(Number);
      Root, Pers: Number;
   begin
      for I in Inputs'Range loop
         Compute(Inputs(I), Root, Pers, Base);
         NIO.Put(Inputs(I), Base => Integer(Base), Width => 12);
         NIO.Put(Root, Base => Integer(Base), Width => 9);
         NIO.Put(Pers, Base => Integer(Base), Width => 12);
         TIO.Put_Line("   " & Base_Type'Image(Base));
      end loop;
   end Print_Roots;
begin
   TIO.Put_Line("      Number     Root Persistence  Base");
   Print_Roots((961038, 923594037444, 670033, 448944221089), Base => 10);
   Print_Roots((16#7e0#, 16#14e344#, 16#12343210#), Base => 16);
end Digital_Root;
