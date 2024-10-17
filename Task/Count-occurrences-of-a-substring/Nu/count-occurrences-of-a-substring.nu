def 'str count' [s: string] {
  split row $s | length | $in - 1
}

{th: 'the three truths' abab: 'ababababab'} | items {|k v| $v | str count $k }
