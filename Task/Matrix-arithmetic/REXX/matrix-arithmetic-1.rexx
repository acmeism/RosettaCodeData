/* REXX ***************************************************************
* Test the two functions determinant and permanent
* using the matrix specifications shown for other languages
* 21.05.2013 Walter Pachl
**********************************************************************/
Call test ' 1  2',
          ' 3  4',2

Call test ' 1  2  3  4',
          ' 4  5  6  7',
          ' 7  8  9 10',
          '10 11 12 13',4

Call test ' 0  1  2  3  4',
          ' 5  6  7  8  9',
          '10 11 12 13 14',
          '15 16 17 18 19',
          '20 21 22 23 24',5

Exit

test:
/**********************************************************************
* Show the given matrix and compute and show determinant and permanent
**********************************************************************/
Parse Arg as,n
asc=as
Do i=1 To n
  ol=''
  Do j=1 To n
    Parse Var asc a.i.j asc
    ol=ol right(a.i.j,3)
    End
   Say ol
  End
Say 'determinant='right(determinant(as),7)
Say '  permanent='right(permanent(as),7)
Say copies('-',50)
Return
