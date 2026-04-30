generic
   type Element_Type is digits <>;
   type Index_Type is (<>);
   type Array_Type is array(Index_Type range <>) of Element_Type;
package Shell_Sort is
   procedure Sort(Item : in out Array_Type);
end Shell_Sort;
