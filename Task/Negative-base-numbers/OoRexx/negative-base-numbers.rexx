/* REXX ---------------------------------------------------------------
* Adapt for ooRexx (use of now invalid variable names)
* and make it work for base -63 (Algol example)
*--------------------------------------------------------------------*/
Numeric Digits 20
digits='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz '
txt=' converted to base '
n=      10;  b= -2;  nb=nBase(n,b);  Say right(n,20) txt right(b,3) '---->' nb ok()
n=     146;  b= -3;  nb=nBase(n,b);  Say right(n,20) txt right(b,3) '---->' nb ok()
n=      15;  b=-10;  nb=nBase(n,b);  Say right(n,20) txt right(b,3) '---->' nb ok()
n=     -15;  b=-10;  nb=nBase(n,b);  Say right(n,20) txt right(b,3) '---->' nb ok()
n=       0;  b= -5;  nb=nBase(n,b);  Say right(n,20) txt right(b,3) '---->' nb ok()
n=-6284695;  b=-62;  nb=nBase(n,b);  Say right(n,20) txt right(b,3) '---->' nb ok()
n=-36492107981104; b=-63;nb=nBase(n,b); Say right(n,20) txt right(b,3) '---->' nb ok()
Exit

nBase: Procedure Expose digits
/*---------------------------------------------------------------------
* convert x (base 10) to result (base r)
*--------------------------------------------------------------------*/
  Parse arg x,r
  result=''
  Do While x\==0              /*keep Processing while  X  isn't zero.*/
    z=x//r
    x=x%r                     /*calculate remainder; calculate int ÷.*/
    If z<0 Then Do
      z=z-r                   /*subtract a negative  R  from  Z ?--+ */
      x=x+1                   /*bump  X  by one.                   ¦ */
      End
    result=substr(digits,z+1,1)result        /*prepend the new digit */
    End
  If result='' Then result=0
  Return result

pBase: Procedure Expose digits;
/*---------------------------------------------------------------------
* convert x (base r) to result (base 10)
*--------------------------------------------------------------------*/
  Parse arg x,r;
  result=0;
  p=0
  len=length(x)
  Do j=len by -1 For len            /*Process each of the X's digits */
    v=pos(substr(x,j,1),digits)-1   /*use digit's numeric value.     */
    result=result+v*r**p;           /*add it to result               */
    p=p+1                           /*bump power by 1                */
    End
  Return result

ok:
/*---------------------------------------------------------------------
* check back conversion
*--------------------------------------------------------------------*/
  back=pBase(nb,b)
  If back\=n  Then
    r='Error backward conversion results in' back
  Else
    r='ok'
  Return r
