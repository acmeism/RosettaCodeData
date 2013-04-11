-----------------------------------------------------------------------
-- Generic Quicksort procedure
-----------------------------------------------------------------------
generic
    type Element_Type is private;
   type Index_Type is (<>);
   type Element_Array is array(Index_Type range <>) of Element_Type;
   with function "<" (Left, Right : Element_Type) return Boolean is <>;
   with function ">" (Left, Right : Element_Type) return Boolean is <>;
procedure Sort(Item : in out Element_Array);
