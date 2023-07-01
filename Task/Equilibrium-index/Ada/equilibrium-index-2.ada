package body Equilibrium is

   function Get_Indices (From : Array_Type) return Index_Vectors.Vector is
      Result : Index_Vectors.Vector;
      Right_Sum, Left_Sum : Element_Type := Zero;
   begin
      for Index in Index_Type'Range loop
         Right_Sum := Right_Sum + Element (From, Index);
      end loop;
      for Index in Index_Type'Range loop
         Right_Sum := Right_Sum - Element (From, Index);
         if Left_Sum = Right_Sum then
            Index_Vectors.Append (Result, Index);
         end if;
         Left_Sum := Left_Sum + Element (From, Index);
      end loop;
      return Result;
   end Get_Indices;

end Equilibrium;
