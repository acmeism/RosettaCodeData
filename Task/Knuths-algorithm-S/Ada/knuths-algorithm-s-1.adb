generic
   Sample_Size: Positive;
   type Item_Type is private;
package S_Of_N_Creator is

   subtype Index_Type is Positive range 1 .. Sample_Size;
   type Item_Array is array (Index_Type) of Item_Type;

   procedure Update(New_Item: Item_Type);
   function Result return Item_Array;

end S_Of_N_Creator;
