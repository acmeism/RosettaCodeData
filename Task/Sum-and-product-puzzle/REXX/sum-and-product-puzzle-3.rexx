/*---------------------------------------------------------------------
* X and Y are two different whole numbers greater than 1.
* Their sum is no greater than 100, and Y is greater than X.
* S and P are two mathematicians (and consequently perfect logicians);
* S knows the sum X+Y and P knows the product X*Y.
* Both S and P know all the information in this paragraph.
*
* The following conversation occurs:
*
* * S says "P does not know X and Y."
* * P says "Now I know X and Y."
* * S says "Now I also know X and Y!"
*
* What are X and Y?
*--------------------------------------------------------------------*/
Call time 'R'
max=100
Products.=0
all=''
Do x=2 To max
  Do y=x+1 To max-2
    If x+y<=100 Then Do
      all=all x'/'y
      prod=x*y; Products.prod=Products.prod+1
      End
    End
  End
Say "There are" words(all) "pairs where X+Y <=" max "(and X<Y)"
/*---------------------------------------------------------------------
* First eliminate all pairs where the product is unique:
* For each pair we look at the decompositions of the sum (x+y).
* If for any of these decompositions (xa/ya) the product is unique
* then x/y cannot be the solution of the puzzle and we eliminate it
* from the list of possible pairs
*--------------------------------------------------------------------*/
sPairs=''
Do i=1 To words(all)
  xy=word(all,i)
  Parse Var xy x '/' Y
  Parse Var xy xx '/' Yy
  s=x+y
  take=1
  Do xa=2 To s/2
    ya=s-xa
    prod=xa*ya
    If products.prod=1 Then Do
      take=0
      Iterate i
      End
    End
  If take Then
    sPairs=sPairs xy
  End
Say "S starts with" words(sPairs) "possible pairs."

/*---------------------------------------------------------------------
* From the REMAINING pairs take only these where the product is unique:
* For each pair we look at the decompositions of the known product.
* If for any of these decompositions (xb/yb) the product is unique
* then xb/yb can be the solution of the puzzle and we add it
* to the list of possible pairs.
*--------------------------------------------------------------------*/
sProducts.=0
Do i=1 To words(sPairs)
  xy=word(sPairs,i)
  Parse Var xy x '/' y
  prod=x*y
  sProducts.prod=sProducts.prod+1
  End
pPairs=''
Do i=1 To words(sPairs)
  xy=word(sPairs,i)
  Parse Var xy x '/' y
  prod=x*y
  If sProducts.prod=1 Then
    pPairs=pPairs xy
  End
Say "P then has" words(pPairs) "possible pairs."

/*---------------------------------------------------------------------
* From the now REMAINING pairs take only these where the sum is unique
* Now we look at all possible pairs and find the one (xc/yc)
* with a unique sum which must be the sum we knew from the beginning.
* The pair xc/yc is then the solution
*--------------------------------------------------------------------*/
Sums.=0
Do i=1 To words(pPairs)
  xy=word(pPairs,i)
  Parse Var xy x '/' y
  sum=x+y
  Sums.sum=Sums.sum+1
  End
final=''
Do i=1 To words(pPairs)
  xy=word(pPairs,i)
  Parse Var xy x '/' y
  sum=x+y
  If Sums.sum=1 Then
    final = final xy
  End
Select
  When words(final)=1 Then Say "Answer:" strip(final)
  When words(final)=0 Then Say "No possible answer."
  Otherwise Do;            Say words(final) "possible answers:"
                           Say strip(final)
    End
  End
Say "Elapsed time:" time('E') "seconds"
Exit
