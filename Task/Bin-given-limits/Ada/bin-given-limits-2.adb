pragma Ada_2012;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body binning is

   ---------------
   -- Is_Sorted --
   ---------------

   function Is_Sorted (Item : Nums_Array) return Boolean is
   begin
      return
        (for all i in Item'First .. Item'Last - 1 => Item (i) < Item (i + 1));
   end Is_Sorted;

   ----------
   -- Bins --
   ----------

   function Bins (Limits : Limits_Array; Data : Nums_Array) return Nums_Array
   is
      Result : Nums_Array (Limits'First .. Limits'Last + 1) := (others => 0);
      Bin_Index : Natural;
   begin
      for value of Data loop
         Bin_Index := Result'First;
         for I in reverse Limits'Range loop
            if value >= Limits (I) then
               Bin_Index := I + 1;
               exit;
            end if;
         end loop;
         Result (Bin_Index) := Result (Bin_Index) + 1;
      end loop;
      return Result;
   end Bins;

   -----------
   -- Print --
   -----------

   procedure Print (Limits : Limits_Array; Bin_Result : Nums_Array) is
   begin
      if Limits'Length = 0 then
         return;
      end if;
      Put ("           < ");
      Put (Item => Limits (Limits'First), Width => 3);
      Put (": ");
      Put (Item => Bin_Result (Bin_Result'First), Width => 2);
      New_Line;
      for i in Limits'First + 1 .. Limits'Last loop
         Put (">= ");
         Put (Item => Limits (i - 1), Width => 3);
         Put (" and < ");
         Put (Item => Limits (i), Width => 3);
         Put (": ");
         Put (Item => Bin_Result (i), Width => 2);
         New_Line;
      end loop;
      Put (">= ");
      Put (Item => Limits (Limits'Last), Width => 3);
      Put ("          : ");
      Put (Item => Bin_Result (Bin_Result'Last), Width => 2);
      New_Line;
   end Print;

end binning;
