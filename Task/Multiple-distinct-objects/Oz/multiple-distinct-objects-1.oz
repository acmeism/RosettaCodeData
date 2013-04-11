declare
  Xs = {MakeList 5} %% a list of 5 unbound variables
in
  {ForAll Xs OS.rand} %% fill it with random numbers (CORRECT)
  {Show Xs}
