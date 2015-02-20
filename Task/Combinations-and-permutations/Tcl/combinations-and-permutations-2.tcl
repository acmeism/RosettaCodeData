# Using the exact integer versions
puts "A sample of Permutations from 1 to 12:"
for {set i 4} {$i <= 12} {incr i} {
    set ii [expr {$i - 2}]
    set iii [expr {$i - int(sqrt($i))}]
    puts "$i P $ii = [expr {P($i,$ii)}], $i P $iii = [expr {P($i,$iii)}]"
}
puts "A sample of Combinations from 10 to 60:"
for {set i 10} {$i <= 60} {incr i 10} {
    set ii [expr {$i - 2}]
    set iii [expr {$i - int(sqrt($i))}]
    puts "$i C $ii = [expr {C($i,$ii)}], $i C $iii = [expr {C($i,$iii)}]"
}
# Using the approximate floating point versions
puts "A sample of Permutations from 5 to 15000:"
for {set i 5} {$i <= 150} {incr i 10} {
    set ii [expr {$i - 2}]
    set iii [expr {$i - int(sqrt($i))}]
    puts "$i P $ii = [expr {fP($i,$ii)}], $i P $iii = [expr {fP($i,$iii)}]"
}
puts "A sample of Combinations from 100 to 1000:"
for {set i 100} {$i <= 1000} {incr i 100} {
    set ii [expr {$i - 2}]
    set iii [expr {$i - int(sqrt($i))}]
    puts "$i C $ii = [expr {fC($i,$ii)}], $i C $iii = [expr {fC($i,$iii)}]"
}
