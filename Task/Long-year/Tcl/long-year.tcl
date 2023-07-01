## Reference: https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year

proc p {year} {
    return [expr {($year + ($year/4) - ($year/100) + ($year/400)) % 7}]
}

proc is_long_year {year} {
    return [expr {[p $year] == 4 || [p [expr {$year - 1}]] == 3}]
}

proc print_long_years {from to} {
    for {set year $from; set count 0} {$year <= $to} {incr year} {
        if {[is_long_year $year]} {
            if {$count > 0} {
                puts -nonewline [expr {($count % 10 == 0) ? "\n" : " "}]
            }
            puts -nonewline $year
            incr count
        }
    }
}

puts "Long years between 1800 and 2100:"
print_long_years 1800 2100
puts ""
