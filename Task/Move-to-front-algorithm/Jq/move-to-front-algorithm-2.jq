("abcdefghijklmnopqrstuvwxyz" | explode) as $ST
  | ("broood", "bananaaa", "hiphophiphop")
  | . as $string
  | m2f_encode($ST)
  | . as $encoded
  | m2f_decode($ST) as $decoded
  | if $string == $decoded then "\($string) => \($encoded) => \($decoded)"
    else "INTERNAL ERROR: encoding of \($string) => \($encoded) => \($decoded)"
    end
