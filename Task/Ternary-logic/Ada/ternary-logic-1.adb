package Logic is
   type Ternary is (True, Unknown, False);

   -- logic functions
   function "and"(Left, Right: Ternary) return Ternary;
   function "or"(Left, Right: Ternary) return Ternary;
   function "not"(T: Ternary) return Ternary;
   function Equivalent(Left, Right: Ternary) return Ternary;
   function Implies(Condition, Conclusion: Ternary) return Ternary;

   -- conversion functions
   function To_Bool(X: Ternary) return Boolean;
   function To_Ternary(B: Boolean) return Ternary;
   function Image(Value: Ternary) return Character;
end Logic;
