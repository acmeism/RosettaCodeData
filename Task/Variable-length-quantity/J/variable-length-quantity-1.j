N=: 128x
v2i=: (N&| N&#./.~ [: +/\ _1 |. N&>)@i.~&a.
i2v=: a. {~ [:;}.@(N+//.@,:N&#.inv)&.>
ifv=: v2i :. i2v
vfi=: i2v :. v2i
av=: 3 u: ]
