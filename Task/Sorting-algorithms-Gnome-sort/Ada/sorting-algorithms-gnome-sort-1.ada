generic
   type Element_Type is private;
   type Index is (<>);
   type Collection is array(Index) of Element_Type;
   with function "<=" (Left, Right : Element_Type) return Boolean is <>;
procedure Gnome_Sort(Item : in out Collection);
