set dict1 [dict create name "Rocket Skates" price 12.75 color yellow]
set dict2 [dict create price 15.25 color red year 1974]
dict for {key val} [dict merge $dict1 $dict2] {
    puts "$key: $val"
}
