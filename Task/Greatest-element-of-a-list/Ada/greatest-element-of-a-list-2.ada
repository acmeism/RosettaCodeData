generic
   type Item is digits <>;
   type Items_Array is array (Positive range <>) of Item;
function Generic_Max (List : Items_Array) return Item;
