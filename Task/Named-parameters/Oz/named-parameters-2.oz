declare
proc {Foo PP Other=unit(named1:N1 named2:N2 ...)}
   NWD = {CondSelect Other namedWithDefault 42}
in
      {System.showInfo "PP: "#PP#", N1: "#N1#", N2: "#N2#", NWD: "#NWD}
end

{Foo 1 unit(named1:2 named2:3 namedWithDefault:4)}
{Foo 1 unit(named2:2 named1:3)}
{Foo 1 unit(named1:2)} %% not ok...
