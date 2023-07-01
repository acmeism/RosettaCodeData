set str "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
set enc [encode $str] ;# ==> {12 W 1 B 12 W 3 B 24 W 1 B 14 W}
set dec [decode $enc]
if {$str eq $dec} {
    puts "success"
}
