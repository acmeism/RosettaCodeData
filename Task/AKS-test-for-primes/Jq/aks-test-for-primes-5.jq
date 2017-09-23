def is_prime:
  . as $N
  | if . < 2 then false
    else (1+.) | optpascal
    | all(  .[2:][]; . % $N == 0 )
    end;
