def mydict: {"hello":13, "world": 31, "!": 71};

# Iterating over the keys
mydict | keys[]
# "!"
# "hello"
# "world"

# Iterating over the values:
mydict[]
# 13
# 31
# 71

# Generating a stream of {"key": key, "value": value} objects:
mydict | to_entries[]
# {"key":"hello","value":13}
# {"key":"world","value":31}
# {"key":"!","value":71}

# Generating a stream of [key,value] arrays:
mydict | . as $o | keys[] | [., $o[.]]
#["!",71]
#["hello",13]
#["world",31]

# Generating a stream of [key,value] arrays, without sorting (jq > 1.4 required)
mydict | . as $o | keys_unsorted[] | [., $o[.]]
# ["hello",13]
# ["world",31]
# ["!",71]
