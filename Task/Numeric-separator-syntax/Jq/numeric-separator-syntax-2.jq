[ 1e6, 1e9, 123456789, -123456789012, 1e20, "e20", -10e19, 123456789123456789123456789 ] as $nums
| [",", ".", " ", "*"] as $seps
| range(0;$nums|length) as $i
| $nums[$i] | commatize($seps[$i] // ",")
