if {[catch { ''... code that might give error ...'' } result]} {
    puts "Error was $result"
} else {
    ''... process $result ...''
}
