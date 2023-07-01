## Creation of an entity representing an empty binary string

[]

## Assignment

# Unless a check is appropriate, assignment can be done in the
# usual ways, for example:

[0] as $x    # assignment to a variable, $x

s as $x      # assignment of s to a variable

.key = s     # assignment to a key in a JSON object

# If s must be checked, these become:

(s|check_binary) as $x

.key = (s|check_binary)

## Concatenation:

str+str2

## Comparison

[72,101,108,108,111] == ("Hello"|explode)  # evaluates to true

# Other jq comparison operators (!=, <, >, <=, >=) can be used as well.

## Cloning and copying
# In jq, all entities are immutable and so the distinction between
# copying and cloning is irrelevant in jq.
# For example, consider the expression "$s[0] = 1"
# in the following:

[0] as $s | $s[0] = 1 | $s

# The result is [0] because the expression "$s[0] = 1"
# evaluates to [1] but does not alter $s.  The value of
# $s can be changed by assignment, e.g.

[0] as $s | $s[0] = 1 | . as $s

## Check if an entity represents the empty binary string

length == 0
# or
s == []

## append a byte, b

s + [b]                 # if the byte, b, is known to be in range
s + ([b]|check_binary)  # if b is suspect

## Extract a substring from a string

# jq uses an index origin of 0 for both JSON arrays strings,
# so to extract the substring with indices from m to (n-1)
# inclusive, the expression s[m:n] can be used.

# There are many other possibilities, such as s[m:], s[-1], etc.

## Replace every occurrence of one byte, x, with
## another sequence of bytes presented as an array, a,
## of byte-valued integers:

reduce .[] as $byte ([];
  if $byte == x then . + a else . + [$byte] end)
