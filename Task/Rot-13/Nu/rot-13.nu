let map = (
  seq char A Z | zip (seq char a z) | flatten
  | into record | [$in $in] | headers | first
  | roll left -c -b 26
)

def rot13 [] {
  split chars | each {|c| $map | get -i -s $c | default $c } | str join
}
