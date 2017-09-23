# In jq 1.4 or later:
jq -n '"abcdabcd" | indices("bc")'
[
  1,
  5
]
