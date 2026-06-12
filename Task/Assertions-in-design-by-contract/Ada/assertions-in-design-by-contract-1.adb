type Nums_Array is array (Integer range <>) of Integer;

procedure Sort(Arr : in out Nums_Array) with
    Pre => Arr'Length > 1,
    Post => (for all I in Arr'First .. Arr'Last -1 => Arr(I) <= Arr(I + 1));
