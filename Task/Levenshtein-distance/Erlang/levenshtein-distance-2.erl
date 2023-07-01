68> timer:tc(levenshtein,distance,["rosettacode","raisethysword"]).
{774799,8} % {Time, Result}
69> timer:tc(levenshtein,distance_cached,["rosettacode","raisethysword"]).
{659,8}
70> timer:tc(levenshtein,distance,["kitten","sitting"]).
{216,3}
71> timer:tc(levenshtein,distance_cached,["kitten","sitting"]).
{213,3}
