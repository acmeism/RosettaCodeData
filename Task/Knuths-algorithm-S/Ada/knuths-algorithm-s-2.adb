with Ada.Numerics.Float_Random, Ada.Numerics.Discrete_Random;

package body S_Of_N_Creator is

   package F_Rnd renames Ada.Numerics.Float_Random;
   F_Gen: F_Rnd.Generator;

   package D_Rnd is new Ada.Numerics.Discrete_Random(Index_Type);
   D_Gen: D_Rnd.Generator;

   Item_Count: Natural := 0; -- this is a global counter
   Sample: Item_Array; -- also used globally

   procedure Update(New_Item: Item_Type) is
   begin
      Item_Count := Item_Count + 1;
      if Item_Count <= Sample_Size then
         -- select the first Sample_Size items as the sample
         Sample(Item_Count) := New_Item;
      else
         -- for I-th item, I > Sample_Size: Sample_Size/I chance of keeping it
         if (Float(Sample_Size)/Float(Item_Count)) > F_Rnd.Random(F_Gen)  then
            -- randomly (1/Sample_Size) replace one of the items of the sample
            Sample(D_Rnd.Random(D_Gen)) := New_Item;
         end if;
      end if;
   end Update;

   function Result return Item_Array is
   begin
      Item_Count := 0; -- ready to start another run
      return Sample;
   end Result;

begin
   D_Rnd.Reset(D_Gen); -- at package instantiation, initialize rnd-generators
   F_Rnd.Reset(F_Gen);
end S_Of_N_Creator;
