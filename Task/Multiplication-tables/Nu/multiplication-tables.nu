1..12 | each {|x|
  1..12 | each {|y|
    if $x > $y and $y > 1 { '' } else { $x * $y }
  }
  | fill -a r -w 4 | str join
}
| str join "\n"
