package P is
   type T is private; -- No components visible
   procedure F (X : in out T); -- The only visible operation
   N : constant T; -- A constant, which value is hidden
private
   type T is record -- The implementation, visible to children only
      Component : Integer;
   end record;
   procedure V (X : in out T); -- Operation used only by children
   N : constant T := (Component => 0); -- Constant implementation
end P;
