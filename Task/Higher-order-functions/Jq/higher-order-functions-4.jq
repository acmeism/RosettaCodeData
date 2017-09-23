# Are all integers between 1 and 5 even?
# For this example, we will use all/2 even
# though it requires a release of jq after jq 1.4;
# we do so to highlight the fact that all/2
# terminates the generator once the condition is satisfied:
all( range(1;6); is_even )
false

# Display the even integers in the given range:
range(1;6) | select(is_even)
2
4

# Evaluate is_even for each integer in an array
[range(1;6)] | map(is_even)
[false, true, false, true, false]

# Note that in jq, there is actually no need to call
# a higher-order function in cases like this.
# For example one can simply write:
range(1;6) | is_even
false
true
false
true
false
