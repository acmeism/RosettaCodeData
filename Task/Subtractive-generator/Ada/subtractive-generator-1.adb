package Subtractive_Generator is
   type State is private;
   procedure Initialize (Generator : in out State; Seed : Natural);
   procedure Next (Generator : in out State; N : out Natural);
private
   type Number_Array is array (Natural range <>) of Natural;
   type State is record
      R    : Number_Array (0 .. 54);
      Last : Natural;
   end record;
end Subtractive_Generator;
