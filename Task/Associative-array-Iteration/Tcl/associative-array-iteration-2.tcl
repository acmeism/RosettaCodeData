set myDict [dict create ...]; # Make the dictionary

# Iterate over keys and values
dict for {key value} $myDict {
    puts "$key -> $value"
}

# Iterate over keys
foreach key [dict keys $myDict] {
    puts "key = $key"
}

# Iterate over values
foreach value [dict values $myDict] {
    puts "value = $value"
}
