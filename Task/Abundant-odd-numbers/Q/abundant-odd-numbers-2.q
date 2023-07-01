q)count A:Filter[abundant] 1+2*til 260000      / a batch of abundant odd numbers; 1000+ is enough
1054

q)1 sd'\25#A                                   / first 25 abundant odd numbers, and the sum of their divisors
945 1575 2205 2835 3465 4095 4725 5355 5775 5985 6435 6615 6825 7245 7425 7875 8085 8415 8505 8925 9135 9555 9765  10395 11025
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 8349 8331 8433 8967 8931 9585 9597 10203 12645 11946

q)1 sd\A 999                                   / 1000th abundant odd number and the sum of its divisors
492975 519361

q)1 sd\(not abundant@)(2+)/1000000000-1        / first abundant odd number above 1,000,000,000 and its divisors
1000000575 1083561009
