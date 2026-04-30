generic
   type Element_Type is private;
   type Index_Type is (<>);
   type Collection is array(Index_Type range <>) of Element_Type;
   with function "<" (Left, right : element_type) return boolean is <>;
procedure Generic_Heapsort(Item : in out Collection);
