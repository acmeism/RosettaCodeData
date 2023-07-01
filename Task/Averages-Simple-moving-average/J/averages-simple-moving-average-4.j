avg=: +/ % #
SEQ=:''
moveAvg=:4 :0"0
   SEQ=:SEQ,y
   avg ({.~ x -@<. #) SEQ
)

   5 moveAvg 1 2 3 4 5 5 4 3 2 1
1 1.5 2 2.5 3 3.8 4.2 4.2 3.8 3
