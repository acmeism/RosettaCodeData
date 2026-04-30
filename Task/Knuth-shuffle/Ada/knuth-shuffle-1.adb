generic
   type Element_Type is private;
   type Array_Type is array (Positive range <>) of Element_Type;

procedure Generic_Shuffle (List : in out Array_Type);
