with Ada.Text_IO, Random_57;

procedure R57 is

   use Random_57;

   type Fun is access function return Mod_7;

   function Rand return Mod_7 renames Random_57.Random7;
   -- change this to "... renames Random_57.Simple_Random;" if you like

   procedure Test(Sample_Size: Positive; Rand: Fun; Precision: Float := 0.3) is

      Counter: array(Mod_7) of Natural := (others => 0);
      Expected: Natural := Sample_Size/7;
      Small: Mod_7 := Mod_7'First;
      Large: Mod_7 := Mod_7'First;

      Result: Mod_7;
   begin
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line("Sample Size: " & Integer'Image(Sample_Size));
      Ada.Text_IO.Put( " Bins:");
      for I in 1 .. Sample_Size loop
         Result := Rand.all;
         Counter(Result) := Counter(Result) + 1;
      end loop;
      for J in Mod_7 loop
         Ada.Text_IO.Put(Integer'Image(Counter(J)));
         if Counter(J) < Counter(Small) then Small := J; end if;
         if Counter(J) > Counter(Large)  then Large := J;  end if;
      end loop;
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line(" Small Bin:" & Integer'Image(Counter(Small)));
      Ada.Text_IO.Put_Line(" Large Bin: " & Integer'Image(Counter(Large)));

      if Float(Counter(Small)*7) * (1.0+Precision) < Float(Sample_Size) then
         Ada.Text_IO.Put_Line("Failed! Small too small!");
      elsif Float(Counter(Large)*7) * (1.0-Precision) > Float(Sample_Size) then
         Ada.Text_IO.Put_Line("Failed! Large too large!");
      else
         Ada.Text_IO.Put_Line("Passed");
      end if;
   end Test;

begin
   Test(    10_000, Rand'Access, 0.08);
   Test(   100_000, Rand'Access, 0.04);
   Test( 1_000_000, Rand'Access, 0.02);
   Test(10_000_000, Rand'Access, 0.01);
end R57;
