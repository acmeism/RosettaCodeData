rot13 := function(s)
  local upper, lower, c, n, t;
  upper := "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  lower := "abcdefghijklmnopqrstuvwxyz";
  t := [ ];
  for c in s do
    n := Position(upper, c);
    if n <> fail then
      Add(t, upper[((n+12) mod 26) + 1]);
    else
      n := Position(lower, c);
      if n <> fail then
        Add(t, lower[((n+12) mod 26) + 1]);
      else
        Add(t, c);
      fi;
    fi;
  od;
  return t;
end;

a := "England expects that every man will do his duty";
# "England expects that every man will do his duty"
b := rot13(a);
# "Ratynaq rkcrpgf gung rirel zna jvyy qb uvf qhgl"
c := rot13(b);
# "England expects that every man will do his duty"
