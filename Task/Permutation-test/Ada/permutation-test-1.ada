with Ada.Text_IO; with Iterate_Subsets;

procedure Permutation_Test is

   type Group_Type is array(Positive range <>) of Positive;

   Treat_Group: constant Group_Type := (85, 88, 75, 66, 25, 29, 83, 39, 97);
   Ctrl_Group:  constant Group_Type := (68, 41, 10, 49, 16, 65, 32, 92, 28, 98);

   package Iter is new Iterate_Subsets(Treat_Group'Length, Ctrl_Group'Length);

   Full_Group: constant Group_Type(1 .. Iter.All_Elements)
     := Treat_Group & Ctrl_Group;

   function Mean(S: Iter.Subset) return Float is
      Sum: Natural := 0;
   begin
      for I in S'Range loop
         Sum := Sum + Full_Group(S(I));
      end loop;
      return Float(Sum)/Float(S'Length);
   end Mean;

   package FIO is new Ada.Text_IO.Float_IO(Float);

   T_Avg: Float := Mean(Iter.First);
   S_Avg: Float;
   S:     Iter.Subset := Iter.First;
   Equal:  Positive := 1; -- Mean(Iter'First) = Mean(Iter'First)
   Higher: Natural  := 0;
   Lower:  Natural  := 0;

begin -- Permutation_Test;
   -- first, count the subsets with a higher, an equal or a lower mean
   loop
      Iter.Next(S);
      S_Avg := Mean(S);
      if S_Avg = T_Avg then
         Equal := Equal + 1;
      elsif S_Avg >= T_Avg then
         Higher := Higher + 1;
      else
         Lower := Lower + 1;
      end if;
      exit when Iter.Last(S);
   end loop;

   -- second, output the results
   declare
      use Ada.Text_IO;
      Sum: Float := Float(Higher + Equal + Lower);
   begin
      Put("Less or Equal: ");
      FIO.Put(100.0*Float(Lower+Equal) / Sum, Fore=>3, Aft=>1, Exp=>0);
      Put(Integer'Image(Lower+Equal));
      New_Line;
      Put("More:          ");
      FIO.Put(100.0*Float(Higher) / Sum,      Fore=>3, Aft=>1, Exp=>0);
      Put(Integer'Image(Higher));
      New_Line;
   end;
end Permutation_Test;
