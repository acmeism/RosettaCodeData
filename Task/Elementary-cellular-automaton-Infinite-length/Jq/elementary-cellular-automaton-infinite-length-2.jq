# Output: an unbounded stream of the form [count, row]
# giving the rows produced by the eca defined by
# $cells (a string) and $rule (an integer)
def eca_infinite($cells; $rule):

  def notcell: tr("01";"10") ;

  def rule2hash($rule):
    [$rule | stream] as $r
    | reduce range(0;8) as $i ({};
        . + { ($i|[stream]|to_b|lpad(3;"0")): ($r[$i] // 0)});

  rule2hash($rule) as $neighbours2next
  | [0, $cells],
    foreach range(1; infinite) as $i ({c: $cells};
      .c = (.c[0:1]|notcell)*2 + .c + (.c[-1:]|notcell)*2        # Extend and pad the ends
      | .c = ([range(1; .c|length - 1) as $i | $neighbours2next[.c[$i-1:$i+2] ]] | join(""));
      [$i, .c] ) ;
