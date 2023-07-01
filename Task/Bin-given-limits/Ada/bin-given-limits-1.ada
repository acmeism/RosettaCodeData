package binning is
   type Nums_Array is array (Natural range <>) of Integer;
   function Is_Sorted (Item : Nums_Array) return Boolean;
   subtype Limits_Array is Nums_Array with
        Dynamic_Predicate => Is_Sorted (Limits_Array);
   function Bins (Limits : Limits_Array; Data : Nums_Array) return Nums_Array;
   procedure Print (Limits : Limits_Array; Bin_Result : Nums_Array);
end binning;
