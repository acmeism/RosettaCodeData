>> [S,V] = fourBitAdder([0 0 0 1],[1 1 1 1])

S =

     0     0     0     0


V =

     1

>> [S,V] = fourBitAdder([0 0 0 1;0 0 1 0],[0 0 0 1;0 0 0 1])

S =

     0     0     1     0
     0     0     1     1


V =

     0
     0

>> [S,V] = fourBitAdder(dec2bin(10,4),dec2bin(1,4))

S =

1  0  1  1


V =

0

>> [S,V] = fourBitAdder(dec2bin([10 11],4),dec2bin([1 1],4))

S =

1  0  1  1
1  1  0  0


V =

0
0

>> bin2dec(S)

ans =

    11
    12
