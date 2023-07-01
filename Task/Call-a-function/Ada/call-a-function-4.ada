function H (Int: Integer;
            Fun: not null access function (X: Integer; Y: Integer)
              return Integer);
           return Integer;

...

X := H(A, F'Access) -- assuming X and A are Integers, and F is a function
                     -- taking two Integers and returning an Integer.
