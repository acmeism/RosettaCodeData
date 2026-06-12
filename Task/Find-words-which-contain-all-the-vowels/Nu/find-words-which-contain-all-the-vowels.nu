let pat = [a e i o u] | each {|v| $"\(?i)^[^($v)]*($v)[^($v)]*$" }

open 'unixdict.txt' | split words -l 11 | where ($pat | all { $it =~ $in })
