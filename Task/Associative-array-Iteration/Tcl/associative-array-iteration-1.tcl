array set myAry {
    # list items here...
}

# Iterate over keys and values
foreach {key value} [array get myAry] {
    puts "$key -> $value"
}

# Iterate over just keys
foreach key [array names myAry] {
    puts "key = $key"
}

# There is nothing for directly iterating over just the values
# Use the keys+values version and ignore the keys
