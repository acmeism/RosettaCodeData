  def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

  INDEX(inputs | select(length>4); .)
  | .  as $dict
  | keys_unsorted[]
  | select(length > 8)
  | (explode | [.[range(0;length;2)]] | implode) as $odd
  | select( ($odd|length > 4) and $dict[$odd])
  | "\(lpad(10)) : \($odd)"
