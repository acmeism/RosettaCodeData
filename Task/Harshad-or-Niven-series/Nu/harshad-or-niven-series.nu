def 'seq harshad' [] {
  1.. | where $it mod ($it | into string | split chars | into int | math sum) == 0
}

[{ take 20 | str join ' ' } { skip until { $in > 1000 } | first }]
| each {|f| seq harshad | do $f }
| str join ' ... '
