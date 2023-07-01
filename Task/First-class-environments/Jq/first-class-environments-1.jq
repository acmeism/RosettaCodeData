def code:
     # Given an integer as input, compute the corresponding hailstone value:
     def hail: if . % 2 == 0 then ./2|floor else 3*. + 1 end;

     if .value > 1 then (.value |= hail) | .count += 1 else . end;
