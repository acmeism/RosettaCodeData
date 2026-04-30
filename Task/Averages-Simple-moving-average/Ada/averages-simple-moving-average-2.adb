with Ada.Containers.Vectors;

package body Moving is
   use Ada.Containers;

   package Number_Vectors is new Ada.Containers.Vectors
     (Element_Type => Number,
      Index_Type   => Natural);

   Current_List : Number_Vectors.Vector := Number_Vectors.Empty_Vector;

   procedure Add_Number (N : Number) is
   begin
      if Natural (Current_List.Length) >= Max_Elements then
         Current_List.Delete_First;
      end if;
      Current_List.Append (N);
   end Add_Number;

   function Get_Average return Number is
      Average : Number := 0.0;
      procedure Sum (Position : Number_Vectors.Cursor) is
      begin
         Average := Average + Number_Vectors.Element (Position);
      end Sum;
   begin
      Current_List.Iterate (Sum'Access);
      if Current_List.Length > 1 then
         Average := Average / Number (Current_List.Length);
      end if;
      return Average;
   end Get_Average;

   function Moving_Average (N : Number) return Number is
   begin
      Add_Number (N);
      return Get_Average;
   end Moving_Average;

end Moving;
