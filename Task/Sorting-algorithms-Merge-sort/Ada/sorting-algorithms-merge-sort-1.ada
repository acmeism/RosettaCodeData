generic
   type Element_Type is private;
   type Index_Type is (<>);
   type Collection_Type is array(Index_Type range <>) of Element_Type;
   with function "<"(Left, Right : Element_Type) return Boolean is <>;

package Mergesort is
   function Sort(Item : Collection_Type) return Collection_Type;
end MergeSort;
