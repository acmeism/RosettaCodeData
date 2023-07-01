for {set i 0} {$i<=10} {incr i} {puts "$i = [int-bt $i]"}
puts "'+-+'+'+--' = [bt-add +-+ +--] = [bt-int [bt-add +-+ +--]]"
puts "'++'*'++' = [bt-mul ++ ++] = [bt-int [bt-mul ++ ++]]"

set a "+-0++0+"
set b [int-bt -436]
set c "+-++-"
puts "a = [bt-int $a], b = [bt-int $b], c = [bt-int $c]"
set abc [bt-mul $a [bt-sub $b $c]]
puts "a*(b-c) = $abc (== [bt-int $abc])"
