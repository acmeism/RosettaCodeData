"We use one variable, called n. Let it initially be equal to 1. Then keep increasing it by 1 for only as long as the remainder after dividing by a million is not equal to 269,696; finally, show the value of n."
| n |
n := 1.
[ n squared \\ 1000000 = 269696 ] whileFalse: [ n := n + 1 ].
n
