/*REXX program to expand a range of integers into a list. *************
* 09.08.2012 Walter Pachl
**********************************************************************/

  old='-6,-3--1,3-5,7-11,14,15,17-20' /*original list of nums/ranges */

  Say 'old='old                     /*show old list of nums/ranges.  */
  a=translate(old,,',')             /*translate commas to blanks     */
  new=''                            /*new list of numbers (so far).  */

  comma=''
  Do While a<>''                    /* as long as there is input     */
    Parse var a x a                 /* get one element               */
    dashpos=pos('-',x,2)            /* find position of dash, if any */
    If dashpos>0 Then Do            /* element is low-high           */
      Parse Var x low =(dashpos) +1 high /* split the element        */
      Do j=low To high              /* output all numbers in range   */
        new=new||comma||j           /* with separating commas        */
        End
      End
    Else                            /* element is a number           */
      new=new||comma||x             /* append (with comma)           */
    comma=','                       /* from now on use comma         */
    End
  Say 'new='new                     /*show the expanded list         */
