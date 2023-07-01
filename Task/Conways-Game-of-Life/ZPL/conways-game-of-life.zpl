program Life;

config var
     n : integer = 100;

region
     BigR = [0 .. n+1, 0 .. n+1];
     R    = [1 .. n,   1 .. n  ];

direction
     nw   = [-1, -1]; north = [-1, 0]; ne   = [-1, 1];
     west = [ 0, -1];                  east = [ 0, 1];
     sw   = [ 1, -1]; south = [ 1, 0]; se   = [ 1, 1];

var
     TW   : [BigR] boolean; -- The World
     NN   : [R]    integer; -- Number of Neighbours

procedure Life();
begin
     -- Initialize world
     [R]  repeat
          NN := TW@nw   + TW@north + TW@ne   +
                TW@west +            TW@east +
                TW@sw   + TW@south + TW@se;
          TW := (TW & NN = 2) | ( NN = 3);
     until !(|<< TW);
end;
