generic
   type Number is private;
   Zero : Number;
   One  : Number;
   Two  : Number;
   with function Image (X : Number) return String is <>;
   with function "+"   (X, Y : Number) return Number is <>;
   with function "/"   (X, Y : Number) return Number is <>;
   with function "mod" (X, Y : Number) return Number is <>;
   with function ">="  (X, Y : Number) return Boolean is <>;
package Prime_Numbers is
   type Number_List is array (Positive range <>) of Number;

   procedure Put (List : Number_List);

   task type Calculate_Factors is
      entry Start (The_Number : in Number);
      entry Get_Size (Size : out Natural);
      entry Get_Result (List : out Number_List);
   end Calculate_Factors;

end Prime_Numbers;
