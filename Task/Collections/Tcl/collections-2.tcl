# create an empty array
array set h {}
# add some pair
set h(one) 1
set h(two) 2
# add more data
array set h {three 3 four 4 more {5 6 7 8}}
# iterate over it in a couple of ways
foreach key [array names h] {puts "$key -> $h($key)"}
foreach {key value} [array get h]  {puts "$key -> $value"}

# pass by name
proc numkeys_byname {arrayName} {
    upvar 1 $arrayName arr
    puts "array $arrayName has [llength [array names arr]] keys"
}
numkeys_byname h

# pass serialized
proc numkeys_bycopy {l} {
    array set arr $l
    puts "array has [llength [array names arr]] keys"
}
numkeys_bycopy [array get h]
