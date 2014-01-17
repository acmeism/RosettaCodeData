line({X0, Y0}, {X1, Y1}) ->
  SX = step(X0, X1),
  SY = step(Y0, Y1),
  DX = abs(X1 - X0),
  DY = abs(Y1 - Y0),
  Err = DX - DY,
  line({X0, Y0}, {X1, Y1}, {SX, SY}, {DX, DY}, Err, []).

line({X1, Y1}, {X1, Y1}, _, _, _, Acc) ->
  lists:reverse([{X1, Y1} | Acc]);
line({X, Y}, {X1, Y1}, {SX, SY}, {DX, DY}, Err, Acc) ->
  DE = 2 * Err,
  {X0, Err0} = next_x(X, SX, DY, Err, DE),
  {Y0, Err1} = next_y(Y, SY, DX, Err0, DE),
  line({X0, Y0}, {X1, Y1}, {SX, SY}, {DX, DY}, Err1, [{X, Y} | Acc]).

step(P0, P1) when P0 < P1 ->
  1;
step(_, _) ->
  -1.

next_x(X, SX, DY, E, DE) when DE > -DY ->
  {X + SX, E - DY};
next_x(X, _SX, _DY, E, _DE) ->
  {X, E}.

next_y(Y, SY, DX, E, DE) when DE < DX ->
  {Y + SY, E + DX};
next_y(Y, _SY, _DX, E, _DE) ->
  {Y, E}.
