 $ jq -r -n -f Middle_three_digits.jq
123 => 123
12345 => 234
1234567 => 345
987654321 => 654
10001 => 000
-10001 => 000
-123 => 123
-100 => 100
100 => 100
-12345 => 234
1 => invalid length: 1
2 => invalid length: 1
-1 => invalid length: 1
-10 => invalid length: 2
2002 => invalid length: 4
-2002 => invalid length: 4
0 => invalid length: 1
