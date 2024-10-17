const numerals = ('0123456789abcdefghijklmnopqrstuvwxyz' | split chars)

def base [r: int]: int -> string {
  let c = {|x| if $x < $r { {out: $x} } else {out: ($x mod $r) next: ($x // $r)} }
  generate $c $in | reverse | collect {|d| $numerals | get $d.0 ...($d | skip) } | str join
}
