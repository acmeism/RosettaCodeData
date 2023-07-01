set theString "I am a string"
if {[regexp -- {string$} $theString]} {
    puts "Ends with 'string'"
}

if {![regexp -- {^You} $theString]} {
    puts "Does not start with 'You'"
}
