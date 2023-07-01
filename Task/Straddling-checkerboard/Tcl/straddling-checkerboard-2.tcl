StraddlingCheckerboardCypher create demo {
    {{} E T {} A O N {} R I S}
    {2  B C D  F G H J  K L M}
    {6  P Q /  U V W X  Y Z .}
}
set input "One night-it was on the twentieth of March, 1888-I was returning"
set encrypted [demo encode $input]
set output [demo decode $encrypted]
puts "Input:   $input"
puts "Encoded: $encrypted"
puts "Decoded: $output"
