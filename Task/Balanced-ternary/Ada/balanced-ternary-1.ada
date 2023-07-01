with Ada.Finalization;

package BT is

   type Balanced_Ternary is private;

   -- conversions
   function To_Balanced_Ternary (Num : Integer) return Balanced_Ternary;
   function To_Balanced_Ternary (Str : String)  return Balanced_Ternary;
   function To_Integer (Num : Balanced_Ternary)  return Integer;
   function To_string (Num : Balanced_Ternary)   return String;

   -- Arithmetics
   -- unary minus
   function "-" (Left : in Balanced_Ternary)
		return Balanced_Ternary;

   -- subtraction
   function "-" (Left, Right : in Balanced_Ternary)
		return Balanced_Ternary;

   -- addition
   function "+" (Left, Right : in Balanced_Ternary)
		return Balanced_Ternary;
   -- multiplication
   function "*" (Left, Right : in Balanced_Ternary)
		return Balanced_Ternary;

private
   -- a balanced ternary number is a unconstrained array of (1,0,-1)
   -- dinamically allocated, least significant trit leftmost
   type Trit is range -1..1;
   type Trit_Array is array (Positive range <>) of Trit;
   pragma Pack(Trit_Array);

   type Trit_Access is access Trit_Array;

   type Balanced_Ternary is new Ada.Finalization.Controlled
     with record
	Ref : Trit_access;
   end record;

   procedure Initialize (Object : in out Balanced_Ternary);
   procedure Adjust     (Object : in out Balanced_Ternary);
   procedure Finalize   (Object : in out Balanced_Ternary);

end BT;
