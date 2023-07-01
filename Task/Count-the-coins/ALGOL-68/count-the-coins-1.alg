#
  Rosetta Code "Count the coins"
  This is a direct translation of the "naive" Haskell version, using an array
  rather than a list. LWB, UPB, and array slicing makes the mapping very simple:

  LWB > UPB     <=> []
  LWB = UPB     <=> [x]
  a[LWB a]      <=> head xs
  a[LWB a + 1:] <=> tail xs
#

BEGIN
  PROC ways to make change = ([] INT denoms, INT amount) INT :
  BEGIN
    IF amount = 0 THEN
      1
    ELIF LWB denoms > UPB denoms THEN
      0
    ELIF LWB denoms = UPB denoms THEN
      (amount MOD denoms[LWB denoms] = 0 | 1 | 0)
    ELSE
      INT sum := 0;
      FOR i FROM 0 BY denoms[LWB denoms] TO amount DO
        sum +:= ways to make change(denoms[LWB denoms + 1:], amount - i)
      OD;
      sum
    FI
  END;
  [] INT denoms = (25, 10, 5, 1);
  print((ways to make change(denoms, 100), newline))
END
