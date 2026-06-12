seq 0 999
| into string
| filter {|n| split chars | into int | math sum | into string | $in in $n }
| str join ' '
