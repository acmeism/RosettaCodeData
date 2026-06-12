def abc [] {
  (parse -r '([abc])').capture0 | (uniq -c).count | get -i 0 1 2
  | $in.0 == $in.1 and $in.1 == $in.2
}
