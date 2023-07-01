def lcs(xstr; ystr):
  if (xstr == "" or ystr == "") then ""
  else
    xstr[0:1] as $x
    |  xstr[1:] as $xs
    |  ystr[1:] as $ys
    | if ($x == ystr[0:1]) then ($x + lcs($xs; $ys))
      else
        lcs(xstr; $ys) as $one
	| lcs($xs; ystr) as $two
	| if ($one|length) > ($two|length) then $one else $two end
      end
  end;
