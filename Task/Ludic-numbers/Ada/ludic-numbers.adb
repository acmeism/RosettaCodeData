with Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Ludic_Numbers is

   package Lucid_Lists is
      new Ada.Containers.Vectors (Positive, Natural);
   use Lucid_Lists;

   List : Vector;

   procedure Fill is
      use type Ada.Containers.Count_Type;
      Vec   : Vector;
      Lucid : Natural;
      Index : Positive;
   begin
      Append (List, 1);

      for I in 2 .. 22_000 loop
         Append (Vec, I);
      end loop;

      loop
         Lucid := First_Element (Vec);
         Append (List, Lucid);

         Index := First_Index (Vec);
         loop
            Delete (Vec, Index);
            Index := Index + Lucid - 1;
            exit when Index > Last_Index (Vec);
         end loop;

         exit when Length (Vec) <= 1;
      end loop;

   end Fill;

   procedure Put_Lucid (First, Last : in Natural) is
      use Ada.Text_IO;
   begin
      Put_Line ("Lucid numbers " & First'Image & " to " & Last'Image & ":");
      for I in First .. Last loop
         Put (Natural'(List (I))'Image);
      end loop;
      New_Line;
   end Put_Lucid;

   procedure Count_Lucid (Below : in Natural) is
      Count : Natural := 0;
   begin
      for Lucid of List loop
         if Lucid <= Below then
            Count := Count + 1;
         end if;
      end loop;
      Ada.Text_IO.Put_Line ("There are " & Count'Image & " lucid numbers <=" & Below'Image);
   end Count_Lucid;

   procedure Find_Triplets (Limit : in Natural) is

      function Is_Lucid (Value : in Natural) return Boolean is
      begin
         for X in 1 .. Limit loop
            if List (X) = Value then
               return True;
            end if;
         end loop;
         return False;
      end Is_Lucid;

      use Ada.Text_IO;
      Index : Natural;
      Lucid : Natural;
   begin
      Put_Line ("All triplets of lucid numbers <" & Limit'Image);
      Index := First_Index (List);
      while List (Index) < Limit loop
         Lucid := List (Index);
         if Is_Lucid (Lucid + 2) and Is_Lucid (Lucid + 6) then
            Put ("(");
            Put (Lucid'Image);
            Put (Natural'(Lucid + 2)'Image);
            Put (Natural'(Lucid + 6)'Image);
            Put_Line (")");
         end if;
         Index := Index + 1;
      end loop;
   end Find_Triplets;

begin
   Fill;
   Put_Lucid (First => 1,
              Last  => 25);
   Count_Lucid (Below => 1000);
   Put_Lucid (First => 2000,
              Last  => 2005);
   Find_Triplets (Limit => 250);
end Ludic_Numbers;
