# largest common substring
# Uses recursion, taking advantage of jq's TCO
def lcs:
  . as [$x, $y]
  | if ($x|length == 0) or ($y|length == 0) then ""
    else $x[:-1] as $x1
    | $y[:-1] as $y1
    | if $x[-1:] == $y[-1:] then ([$x1, $y1] | lcs) + $x[-1:]
      else ([$x, $y1] | lcs) as $x2
      | ([$x1, $y] | lcs) as $y2
      | if ($x2|length) > ($y2|length) then $x2 else $y2 end
      end
    end;

def scs:
  def eq($s;$i; $t;$j): $s[$i:$i+1] == $t[$j:$j+1];

  . as [$u, $v]
  | lcs as $lcs
  | reduce range(0; $lcs|length) as $i ( { ui: 0, vi: 0, sb: "" };
        until(  .ui == ($u|length) or eq($u;.ui; $lcs;$i);
	    .ui as $ui
            | .sb += $u[$ui:$ui+1]
            | .ui += 1 )
	| until(.vi == ($v|length) or eq($v;.vi; $lcs;$i);
	    .vi as $vi
            | .sb += $v[$vi:$vi+1]
            | .vi += 1 )
        | .sb += $lcs[$i:$i+1]
        | .ui += 1
        | .vi += 1
    )
    | if .ui < ($u|length) then .sb = .sb + $u[.ui:] else . end
    | if .vi < ($v|length) then .sb = .sb + $v[.vi:] else . end
    | .sb ;

[ "abcbdab", "bdcaba" ] | scs
