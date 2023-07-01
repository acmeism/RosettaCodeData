variable r_expres = "-6,-3--1,3-5,7-11,14,15,17-20", s, r_expan = {}, dpos, i;

foreach s (strchop(r_expres, ',', 0))
{
  % S-Lang built-in RE's are fairly limited, and have a quirk:
  %   grouping is done with \\( and \\), not ( and )
  % [PCRE and Oniguruma RE's are available via standard libraries]
  if (string_match(s, "-?[0-9]+\\(-\\)-?[0-9]+", 1)) {

    (dpos, ) = string_match_nth(1);

    % Create/loop-over a "range array": from num before - to num after it:
    foreach i ( [integer(substr(s, 1, dpos)) : integer(substr(s, dpos+2, -1))] )
      list_append(r_expan, string(i));
  }
  else
    list_append(r_expan, s);
}
print(strjoin(list_to_array(r_expan), ", "));
