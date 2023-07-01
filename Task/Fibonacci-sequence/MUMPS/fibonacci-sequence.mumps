FIBOITER(N)
 ;Iterative version to get the Nth Fibonacci number
 ;N must be a positive integer
 ;F is the tree containing the values
 ;I is a loop variable.
 QUIT:(N\1'=N)!(N<0) "Error: "_N_" is not a positive integer."
 NEW F,I
 SET F(0)=0,F(1)=1
 QUIT:N<2 F(N)
 FOR I=2:1:N SET F(I)=F(I-1)+F(I-2)
 QUIT F(N)
