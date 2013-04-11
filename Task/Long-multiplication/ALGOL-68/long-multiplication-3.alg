################################################################
# Finally Define the required INTEGER multiplication OPerator. #
################################################################
OP * = (INTEGER a, b)INTEGER:(

# initialise out to all zeros #
  [UPB a + UPB b]INT ab; FOR place ab TO UPB ab DO ab[place ab]:=0 OD;

  FOR place a FROM UPB a BY next digit TO LWB a DO
    DIGIT carry := 0;

# calculate each digit (whilst removing the carry) #
    FOR place b FROM UPB b BY next digit TO LWB b DO
      # n.b. result may be 2 digits #
      INT result := ab[place a + place b] + a[place a]*b[place b] + carry;
      carry := result % digit base; # avoid MOD as it doesn't under handle -ve numbers #
      ab[place a + place b] := result  - carry * digit base
    OD;
    ab[place a + LWB b + next digit] +:= carry

  OD;
  NORMALISE ab
);
