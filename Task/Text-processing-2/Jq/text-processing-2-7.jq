$ jq -R  '[splits("[ \t]+")]' Text_processing_2.txt | jq -s -r -f  Text_processing_2.jq
field 1 in line 6 has an invalid date: 991-04-03
line 6 has 47 fields
field 2 in line 6 is not a float: 10000
field 3 in line 6 is not an integer: 1.0
field 47 in line 6 is not an integer: x

Checking for duplicate timestamps:
[
  [
    "1991-03-31",
    2
  ]
]

There are 5 valid rows altogether.
