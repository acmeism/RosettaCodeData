Parse Arg str  .                                  /*obtain optional arguments from the CL*/
If str=='' Then str= 'gHHH5YY++///\'        /*Not specified?  Then use the default.*/
i=1
ol=''
Do Forever
  j=verify(str,substr(str,i,1),'N',i,99)  /* find first character that's different */
  If j=0 Then Do                          /* End of strin reached                  */
    ol=ol||substr(str,i)                  /* the final substring                   */
    Leave
    End
  ol=ol||substr(str,i,j-i)', '            /* add substring and delimiter           */
  i=j
  End
Say ol
