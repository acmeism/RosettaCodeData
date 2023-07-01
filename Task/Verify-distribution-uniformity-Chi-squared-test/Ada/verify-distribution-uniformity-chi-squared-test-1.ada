package Chi_Square is

   type Flt is digits 18;
   type Bins_Type is array(Positive range <>) of Natural;

   function Distance(Bins: Bins_Type) return Flt;

end Chi_Square;
