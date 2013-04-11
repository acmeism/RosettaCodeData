proc makeDistribution {operation {count 1000000}} {
    for {set i 0} {$i<$count} {incr i} {incr distribution([uplevel 1 $operation])}
    return [array get distribution]
}

set distFair [makeDistribution {expr int(rand()*5)}]
puts "distribution \"$distFair\" assessed as [expr [isUniform $distFair]?{fair}:{unfair}]"
set distUnfair [makeDistribution {expr int(rand()*rand()*5)}]
puts "distribution \"$distUnfair\" assessed as [expr [isUniform $distUnfair]?{fair}:{unfair}]"
