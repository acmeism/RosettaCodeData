type T is limited private;  -- inner structure is hidden
X, Y: T;
B: Boolean;
-- The following operations do not exist:
X := Y;  -- illegal (cannot be compiled
B := X = Y;  -- illegal
