$ cat toto
1
2
4
8
16
$ cat toto toto | paste -sd*
1*2*4*8*16*1*2*4*8*16
$ cat toto toto | paste -sd* | bc -l
1048576
