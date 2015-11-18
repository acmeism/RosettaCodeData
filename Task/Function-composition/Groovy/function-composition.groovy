final times2 = { it * 2 }
final plus1 = { it + 1 }

final plus1_then_times2 = times2 << plus1
final times2_then_plus1 = times2 >> plus1

assert plus1_then_times2(3) == 8
assert times2_then_plus1(3) == 7
