entity Array_Test is
end entity Array_Test;

architecture Example of Array_test is

   -- Array type have to be defined first
   type Integer_Array is array (Integer range <>) of Integer;

   -- Array index range can be ascending...
   signal A : Integer_Array (1 to 20);

   -- or descending
   signal B : Integer_Array (20 downto 1);

   -- VHDL array index ranges may begin at any value, not just 0 or 1
   signal C : Integer_Array (-37 to 20);

   -- VHDL arrays may be indexed by enumerated types, which are
   -- discrete non-numeric types
   type Days is (Mon, Tue, Wed, Thu, Fri, Sat, Sun);
   type Activities is (Work, Fish);
   type Daily_Activities is array (Days) of Activities;
   signal This_Week : Daily_Activities := (Mon to Fri => Work, Others => Fish);

   type Finger is range 1 to 4; -- exclude thumb
   type Fingers_Extended is array (Finger) of Boolean;
   signal Extended : Fingers_Extended;

   -- Array types may be unconstrained.
   -- Objects of the type must be constrained
   type Arr is array (Integer range <>) of Integer;
   signal Uninitialized : Arr (1 to 10);
   signal Initialized_1 : Arr (1 to 20) := (others => 1);
   constant Initialized_2 : Arr := (1 to 30 => 2);
   constant Const : Arr := (1 to 10 => 1, 11 to 20 => 2, 21 | 22 => 3);
   signal Centered : Arr (-50 to 50) := (0 => 1, others => 0);

   signal Result : Integer;

begin

   A <= (others => 0);           -- Assign whole array
   B <= (1 => 1, 2 => 1,
         3 => 2, others => 0);   -- Assign whole array, different values
   A (1) <= -1;                  -- Assign individual element
   A (2 to 4) <= B (3 downto 1); -- Assign a slice
   A (3 to 5) <= (2, 4, -1);     -- Assign an aggregate
   A (3 to 5) <= A (4 to 6);     -- It is OK to overlap slices when assigned

   -- VHDL arrays does not have 'first' and 'last' elements,
   -- but have 'Left' and 'Right' instead
   Extended (Extended'Left)  <= False; -- Set leftmost element of array
   Extended (Extended'Right) <= False; -- Set rightmost element of array

   Result <= A (A'Low) + B (B'High);

end architecture Example;
