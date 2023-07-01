def task:

  def format: "\(.[0]|lpad(8)) -> \(.[1]|lpad(9)) -> \(.[2])";

  INDEX(inputs | select(length>=4 and isHexWord); .)
  | reduce keys_unsorted[] as $word ([];
        ($word | hex2i) as $num
        | ($num | digital_root) as $dr
        | . + [[ $word, $num, $dr]])
  | sort_by( .[-1] )
  | . as $details

  | (reduce .[] as $line ([];
       if $line[0] | explode | unique | length >= 4
       then . + [$line] else . end)) as $digits4

  | "\($details|length) hex words with 4 or more letters were found:",
    ($details[] | format),
    "",
    "\($digits4|length) such words contain 4 or more different letters:",
     (($digits4|sort_by(.[1])|reverse[] ) | format) ;

task
