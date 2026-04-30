with Ada.Text_IO;
with Ada.Containers.Ordered_Sets;

procedure Yellowstone_Sequence is

   generic  --  Allow more than one generator, but must be instantiated
   package Yellowstones is
      function Next return Integer;
      function GCD (Left, Right : Integer) return Integer;
   end Yellowstones;

   package body Yellowstones
   is
      package Sequences is
        new Ada.Containers.Ordered_Sets (Integer);

      --  Internal package state
      N_0 : Integer := 0;
      N_1 : Integer := 0;
      N_2 : Integer := 0;
      Seq : Sequences.Set;
      Min : Integer := 1;

      function GCD (Left, Right : Integer) return Integer
      is (if Right = 0
          then Left
          else GCD (Right, Left mod Right));

      function Next return Integer is
      begin
         N_2 := N_1;
         N_1 := N_0;
         if N_0 < 3 then
            N_0 := N_0 + 1;
         else
            N_0 := Min;
            while
              not (not Seq.Contains (N_0)
                     and then GCD (N_1, N_0) = 1
                     and then GCD (N_2, N_0) > 1)
            loop
               N_0 := N_0 + 1;
            end loop;
         end if;
         Seq.Insert (N_0);
         while Seq.Contains (Min) loop
            Seq.Delete (Min);
            Min := Min + 1;
         end loop;
         return N_0;
      end Next;

   end Yellowstones;

   procedure First_30 is
      package Yellowstone is new Yellowstones;  --  New generator instance
      use Ada.Text_IO;
   begin
      Put_Line ("First 30 Yellowstone numbers:");
      for A in 1 .. 30 loop
         Put (Yellowstone.Next'Image); Put (" ");
      end loop;
      New_Line;
   end First_30;

begin
   First_30;
end Yellowstone_Sequence;
