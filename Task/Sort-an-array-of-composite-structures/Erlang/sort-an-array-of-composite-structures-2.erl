2> F = fun({_,X},{_,Y}) -> X < Y end.
#Fun<erl_eval.12.113037538>
3> lists:usort(F, [{{2006,2007},"Ducks"},
                   {{2000,2001},"Avalanche"},
                   {{2002,2003},"Devils"},
                   {{2001,2002},"Red Wings"},
                   {{2003,2004},"Lightning"},
                   {{2004,2005},"N/A: lockout"},
                   {{2005,2006},"Hurricanes"},
                   {{1999,2000},"Devils"},
                   {{2007,2008},"Red Wings"},
                   {{2008,2009},"Penguins"}]).
[{{2000,2001},"Avalanche"},
 {{1999,2000},"Devils"},
 {{2002,2003},"Devils"},
 {{2006,2007},"Ducks"},
 {{2005,2006},"Hurricanes"},
 {{2003,2004},"Lightning"},
 {{2004,2005},"N/A: lockout"},
 {{2008,2009},"Penguins"},
 {{2007,2008},"Red Wings"},
 {{2001,2002},"Red Wings"}]
