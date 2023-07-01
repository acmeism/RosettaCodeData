generic
   Subset_Size, More_Elements: Positive;
package Iterate_Subsets is

   All_Elements: Positive := Subset_Size + More_Elements;
   subtype Index is Integer range 1 .. All_Elements;
   type Subset is array (1..Subset_Size) of Index;

   -- iterate over all subsets of size Subset_Size
   -- from the set {1, 2, ..., All_Element}

   function First return Subset;
   procedure Next(S: in out Subset);
   function Last(S: Subset) return Boolean;

end Iterate_Subsets;
