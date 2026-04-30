generic
   Max_Elements : Positive;
   type Number is digits <>;
package Moving is
   procedure Add_Number (N : Number);
   function Moving_Average (N : Number) return Number;
   function Get_Average return Number;
end Moving;
