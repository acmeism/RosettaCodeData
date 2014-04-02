generic
   type Number is private;
   Zero : Number;
   One  : Number;
   Two  : Number;
   with function "+"   (X, Y : Number) return Number is <>;
   with function "/"   (X, Y : Number) return Number is <>;
   with function "mod" (X, Y : Number) return Number is <>;
   with function ">="  (X, Y : Number) return Boolean is <>;
package Prime_Numbers is
   type Number_List is array (Positive range <>) of Number;
   function Decompose (N : Number) return Number_List;
end Prime_Numbers;
