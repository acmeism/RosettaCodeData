def tests: [[[1, 2], 20], [[2, 1] ,20], [[1, 3, 1, 2], 30], [[1, 3, 2, 1], 30]];

tests[] as [$a, $n]
| $a
| [kolakoski($n)] as $k
| "First \($n) of kolakoski sequence for \($a):", $k, "check: \($k | if iskolakoski then "✓" else "❌" end )", ""
