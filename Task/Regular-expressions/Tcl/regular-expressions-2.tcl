set theString "This string has >123< a number in it"
if {[regexp -- {>(\d+)<} $theString -> number]} {
    puts "Contains the number $number"
}
