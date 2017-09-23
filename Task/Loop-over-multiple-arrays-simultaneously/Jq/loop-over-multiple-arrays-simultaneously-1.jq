# zip/0 emits [] if input is [].

def zip:
  . as $in
  | [range(0; $in[0]|length) as $i | $in | map( .[$i] ) ];
