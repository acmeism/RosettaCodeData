def stem_and_leaf:

  # align-right:
  def right: tostring | (4-length) * " " + .;

  sort
  | .[0] as $min
  | .[length-1] as $max
  | "\($min/10|floor|right) | " as $stem
  | reduce .[] as $d
      # state: [ stem, string ]
      ( [ 0, $stem ];
        .[0] as $stem
        | if ($d/10) | floor == $stem
          then [ $stem,     (.[1] +                      "\($d % 10)" )]
          else [ $stem + 1, (.[1] + "\n\($stem+1|right) | \($d % 10)" )]
          end )
  | .[1] ;
