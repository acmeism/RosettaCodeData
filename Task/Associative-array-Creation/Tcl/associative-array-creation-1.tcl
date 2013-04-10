# Create one element at a time:
set hash(foo) 5

# Create in bulk:
array set hash {
    foo 5
    bar 10
    baz 15
}

# Access one element:
set value $hash(foo)

# Output all values:
foreach key [array names hash] {
    puts $hash($key)
}
