PROC random normal = REAL:  # normal distribution, centered on 0, std dev 1 #
(
  sqrt(-2*log(random)) * cos(2*pi*random)
);

test:(
  [1000]REAL rands;
  FOR i TO UPB rands DO
    rands[i] := 1 + random normal/2
  OD;
  INT limit=10;
  printf(($"("n(limit-1)(-d.6d",")-d.5d" ... )"$, rands[:limit]))
)
