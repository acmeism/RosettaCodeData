Name: declare   -- a local declaration block has an optional name
   A : constant Integer := 42;  -- Create a constant
   X : String := "Hello"; -- Create and initialize a local variable
   Y : Integer;           -- Create an uninitialized variable
   Z : Integer renames Y: -- Rename Y (creates a view)
   function F (X: Integer) return Integer is
     -- Inside, all declarations outside are visible when not hidden: X, Y, Z are global with respect to F.
     X: Integer := Z;  -- hides the outer X which however can be referred to by Name.X
   begin
     ...
   end F;  -- locally declared variables stop to exist here
begin
   Y := 1; -- Assign variable
   declare
     X: Float := -42.0E-10;  -- hides the outer X (can be referred to Name.X like in F)
   begin
     ...
   end;
end Name; -- End of the scope
