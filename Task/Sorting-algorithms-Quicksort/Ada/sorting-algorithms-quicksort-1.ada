-----------------------------------------------------------------------
-- Generic Quick_Sort procedure
-----------------------------------------------------------------------
generic
   type Element is private;
   type Index is (<>);
   type Element_Array is array(Index range <>) of Element;
   with function "<" (Left, Right : Element) return Boolean is <>;
procedure Quick_Sort(A : in out Element_Array);
