SUMPROD(A)
 ;Compute the sum and product of the numbers in the array A
 NEW SUM,PROD,POS
 ;SUM is the running sum,
 ;PROD is the running product,
 ;POS is the position within the array A
 SET SUM=0,PROD=1,POS=""
 FOR  SET POS=$ORDER(A(POS)) Q:POS=""  SET SUM=SUM+A(POS),PROD=PROD*A(POS)
 WRITE !,"The sum of the array is "_SUM
 WRITE !,"The product of the array is "_PROD
 KILL SUM,PROD,POS
 QUIT
