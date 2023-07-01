def task:
  [ "A", "ö", "Ж", "€", "𝄞" ][]
  | . as $glyph
  | explode[]
  | utf8_encode as $encoded
  | ($encoded|utf8_decode) as $decoded
  | "Glyph \($glyph) => \($encoded) => \($decoded) => \([$decoded]|implode)" ;

task
