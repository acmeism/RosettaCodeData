set kt [KnightsTour new 7 7]
$kt constructFrom {0 0}
$kt print
if {[$kt isClosed]} {
    puts "This is a closed tour"
} else {
    puts "This is an open tour"
}
