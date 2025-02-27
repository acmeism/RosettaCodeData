(1..100
| each {|i| $"(if $i mod 3 == 0 {"Fizz"})(if $i mod 5 == 0 {"Buzz"})"
| if ($in == "") {$i} else {$in}}
| str join "\n")
