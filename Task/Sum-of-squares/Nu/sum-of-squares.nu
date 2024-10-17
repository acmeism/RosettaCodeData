def sqsum []: {
  reduce -f 0 {|x res| $x * $x + $res }
}
