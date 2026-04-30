with Ada.Containers.Ordered_Maps;
with Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Text_IO;   use Ada.Text_IO;

procedure Power_Tree is

   Debug_On : constant Boolean := False;

   generic
      type Result_Type is private;
      Base     : Result_Type;
      Identity : Result_Type;
      with function "*" (Left, Right : Result_Type) return Result_Type is <>;
   package Knuth_Power_Tree is
      subtype Exponent is Natural;

      function Power (Exp : Exponent) return Result_Type;
   end Knuth_Power_Tree;

   package body Knuth_Power_Tree is

      package Power_Trees is
        new Ada.Containers.Ordered_Maps (Key_Type     => Exponent,
                                         Element_Type => Result_Type);
      Tree : Power_Trees.Map;

      procedure Debug (Item : String) is
      begin
         if Debug_On then
            Put_Line (Standard_Error, Item);
         end if;
      end Debug;

      function Power (Exp : Exponent) return Result_Type is
         Pow : Result_Type;
      begin
         if Tree.Contains (Exp) then
            return Tree.Element (Exp);
         else
            Debug ("lookup failed of " & Exp'Image);
         end if;

         if Exp mod 2 = 0 then
            Debug ("lookup half " & Exponent'(Exp / 2)'Image);
            Pow := Power (Exp / 2);
            Pow := Pow * Pow;
         else
            Debug ("lookup one less " & Exponent'(Exp - 1)'Image);
            Pow := Power (Exp - 1);
            Pow := Result_Type (Base) * Pow;
         end if;
         Debug ("insert " & Exp'Image);
         Tree.Insert (Key => Exp, New_Item => Pow);
         return Pow;
      end Power;

   begin
      Tree.Insert (Key => 0, New_Item => Identity);
   end Knuth_Power_Tree;


   procedure Part_1
   is
      package Power_2 is new Knuth_Power_Tree (Result_Type => Long_Integer,
                                               Base        => 2,
                                               Identity    => 1);
      R : Long_Integer;
   begin
      Put_Line ("=== Part 1 ===");
      for N in 0 .. 25 loop
         R := Power_2.Power (N);
         Put ("2 **");  Put (N'Image);
         Put (" =");    Put (R'Image);
         New_Line;
      end loop;
   end Part_1;

   procedure Part_2
   is
      use Ada.Numerics.Big_Numbers.Big_Integers;

      package Power_3 is new Knuth_Power_Tree (Result_Type => Big_Integer,
                                               Base        => 3,
                                               Identity    => 1);
      R : Big_Integer;
   begin
      Put_Line ("=== Part 2 ===");
      for E in 190 .. 192 loop
         R := Power_3.Power (E);
         Put ("3 **" & E'Image & " =");  Put (R'Image);  New_Line;
      end loop;
   end Part_2;

   procedure Part_3
   is
      subtype Real is Long_Long_Float;
      package Real_IO is new Ada.Text_IO.Float_IO (Real);
      package Power_1_1 is new Knuth_Power_Tree (Result_Type => Real,
                                                 Base        => 1.1,
                                                 Identity    => 1.0);
      R : Real;
   begin
      Put_Line ("=== Part 3 ===");
      for E in 81 .. 84 loop
         R := Power_1_1.Power (E);
         Put ("1.1 **" & E'Image & " = ");
         Real_IO.Put (R, Exp => 0, Aft => 6);
         New_Line;
      end loop;
   end Part_3;

begin
   Part_1;
   Part_2;
   Part_3;
end Power_Tree;
