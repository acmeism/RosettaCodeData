set kt [KnightsTour new]
$kt constructRandom
$kt print
if {[$kt isClosed]} {
    puts "This is a closed tour"
} else {
    puts "This is an open tour"
}
