xmas := function(a, b)
  local y, v;
  v := [ ];
  for y in [a .. b] do
    if WeekDay([25, 12, y]) = "Sun" then
      Add(v, y);
    fi;
  od;
  return v;
end;

xmas(2008, 2121);
# [ 2011, 2016, 2022, 2033, 2039, 2044, 2050, 2061, 2067, 2072, 2078, 2089, 2095, 2101, 2107, 2112, 2118 ]
