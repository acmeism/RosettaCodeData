/* REXX ***************************************************************
* permanent.rex
* compute the permanent of a matrix
* I found an algorithm here:
* http://www.codeproject.com/Articles/21282/Compute-Permanent-of-a-Matrix-with-Ryser-s-Algorit
* see there for the original author.
* translated it to REXX (hopefully correctly) to REXX
* and believe that I can "publish" it here, on rosettacode
* when I look at the copyright rules shown there:
* http://www.codeproject.com/info/cpol10.aspx
* 20.05.2013 Walter Pachl
**********************************************************************/
Call init arg(1)                 /* initialize the matrix (n and a.* */
sum=0
rowsumprod=0
rowsum=0
chi.=0
c=2**n
Do k=1 To c-1                       /* loop all 2^n submatrices of A */
  rowsumprod = 1
  chis=dec2binarr(k,n)              /* characteristic vector         */
  Do ci=0 By 1 While chis<>''
    Parse Var chis chi.ci chis
    End
  Do m=0 To n-1                     /* loop columns of submatrix #k  */
    rowsum = 0
    Do p=0 To n-1                   /* loop rows and compute rowsum  */
      mnp=m*n+p
      rowsum=rowsum+chi.p*A.mnp
      End
    rowsumprod=rowsumprod*rowsum  /* update product of rowsums     */
                            /* (optional -- use for sparse matrices) */
                            /* if (rowsumprod == 0) break;           */
    End
  sum=sum+((-1)**(n-chi.n))*rowsumprod
  End
Return sum
/**********************************************************************
* Notes
* 1.The submatrices are chosen by use of a characteristic vector chi
* (only the columns are considered, where chi[p] == 1).
* To retrieve the t from Ryser's formula, we need to save the number
* n-t, as is done in chi[n]. Then we get t = n - chi[n].
* 2.The matrix parameter A is expected to be a one-dimensional integer
* array -- should the matrix be encoded row-wise or column-wise?
* -- It doesn't matter. The permanent is invariant under
* row-switching and column-switching, and it is Screenshot
* - per_inv.gif .
* 3.Further enhancements: If any rowsum equals zero,
* the entire rowsumprod becomes zero, and thus the m-loop can be broken.
* Since if-statements are relatively expensive compared to integer
* operations, this might save time only for sparse matrices
* (where most entries are zeros).
* 4.If anyone finds a polynomial algorithm for permanents,
* he will get rich and famous (at least in the computer science world).
**********************************************************************/
/**********************************************************************
* At first, we need to transform a decimal to a binary array
* with an additional element
* (the last one) saving the number of ones in the array:
**********************************************************************/
dec2binarr: Procedure
  Parse Arg n,dim
  ol='n='n 'dim='dim
  res.=0
  pos=dim-1
  Do While n>0
    res.pos=n//2
    res.dim=res.dim+res.pos
    n=n%2
    pos=pos-1
    End
  res_s=''
  Do i=0 To dim
    res_s=res_s res.i
    End
  Return res_s

init: Procedure Expose a. n
/**********************************************************************
* a.* (starting with index 0) contains all array elements
* n is the dimension of the square matrix
**********************************************************************/
Parse Arg as
n=sqrt(words(as))
a.=0
Do ai=0 By 1 While as<>''
  Parse Var as a.ai as
  End
Return

sqrt: Procedure
/**********************************************************************
* compute and return the (integer) square root of the given argument
* terminate the program if the argument is not a square
**********************************************************************/
  Parse Arg nn
  Do n=1 By 1 while n*n<nn
    End
  If n*n=nn Then
    Return n
  Else Do
    Say 'invalid number of elements:' nn 'is not a square.'
    Exit
    End
