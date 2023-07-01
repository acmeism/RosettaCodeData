build_path({Sx, Sy}, {Tx, Ty}) ->
  if
    Tx < Sx -> StepX = -1;
    true -> StepX = 1
  end,
  if
    Ty < Sy -> StepY = -1;
    true -> StepY = 1
  end,

  Dx = abs((Tx-Sx)*2),
  Dy = abs((Ty-Sy)*2),

  if
    Dy > Dx -> Path = through_y({Sx, Sy}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, Dx*2-Dy, []);
    true -> Path = through_x({Sx, Sy}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, Dy*2-Dx, [])
  end,

  lists:reverse(Path).

through_x({Tx, _}, {Tx, _}, _, _, _, P) -> P;
through_x({Sx, Sy}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F0, P) when F0 >= 0 ->
  Ny = Sy + StepY,
  F1 = F0 - Dx,
  Nx = Sx + StepX,
        F2 = F1 + Dy,
  through_x({Nx, Ny}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F2, [{Nx, Ny}|P]);
through_x({Sx, Sy}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F0, P) when F0 < 0 ->
  Ny = Sy,
  Nx = Sx + StepX,
        F2 = F0 + Dy,
  through_x({Nx, Ny}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F2, [{Nx, Ny}|P]).

through_y({_, Ty}, {_, Ty}, _, _, _, P) -> P;
through_y({Sx, Sy}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F0, P) when F0 >= 0 ->
  Nx = Sx + StepX,
  F1 = F0 - Dy,
  Ny = Sy + StepY,
        F2 = F1 + Dx,
  through_y({Nx, Ny}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F2, [{Nx, Ny}|P]);
through_y({Sx, Sy}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F0, P) when F0 < 0 ->
  Nx = Sx,
  Ny = Sy + StepY,
        F2 = F0 + Dx,
  through_y({Nx, Ny}, {Tx, Ty}, {StepX, StepY}, {Dx, Dy}, F2, [{Nx, Ny}|P]).
