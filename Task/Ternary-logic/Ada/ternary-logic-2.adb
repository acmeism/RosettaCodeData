package body Logic is
   -- type Ternary is (True, Unknown, False);

   function Image(Value: Ternary) return Character is
   begin
      case Value is
         when True    => return 'T';
         when False   => return 'F';
         when Unknown => return '?';
      end case;
   end Image;

   function "and"(Left, Right: Ternary) return Ternary is
   begin
      return Ternary'max(Left, Right);
   end "and";

   function "or"(Left, Right: Ternary) return Ternary is
   begin
      return Ternary'min(Left, Right);
   end "or";

   function "not"(T: Ternary) return Ternary is
   begin
      case T is
         when False   => return True;
         when Unknown => return Unknown;
         when True    => return False;
      end case;
   end "not";

   function To_Bool(X: Ternary) return Boolean is
   begin
      case X is
         when True  => return True;
         when False => return False;
         when Unknown => raise Constraint_Error;
      end case;
   end To_Bool;

   function To_Ternary(B: Boolean) return Ternary is
   begin
      if B then
         return True;
      else
         return False;
      end if;
   end To_Ternary;

   function Equivalent(Left, Right: Ternary) return Ternary is
   begin
      return To_Ternary(To_Bool(Left) = To_Bool(Right));
   exception
      when Constraint_Error => return Unknown;
   end Equivalent;

   function Implies(Condition, Conclusion: Ternary) return Ternary is
   begin
      return (not Condition) or Conclusion;
   end Implies;

end Logic;
