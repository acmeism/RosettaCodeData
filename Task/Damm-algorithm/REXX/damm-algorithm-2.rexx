/*REXX pgm uses H. Michael Damm's algorithm to validate numbers with suffixed check sum. digit*/
 a.0= 0317598642; a.1= 7092154863; a.2= 4206871359; a.3= 1750983426; a.4= 6123045978
 a.5= 3674209581; a.6= 5869720134; a.7= 8945362017; a.8= 9438617205; a.9= 2581436790
Call Damm 5724, 5727, 112946, 112940         /*invoke Damm's algorithm To some #'s.*/
Exit                                         /*stick a Tok in it,  we're all Done. */
/*---------------------------------------------------------------------------------*/
Damm:
  Do j=1 To arg()                            /* loop over numbers          */
    x=arg(j)
    d=0
    Do p=1 To length(x)-1                  /* compute the checksum digit */
      d=substr(a.d,substr(x,p,1)+1,1)
      end   /*p*/
    z=right(x,1)                             /* the given digit            */
    If z=d Then Say '   valid checksum digit '  z  " for "  x
    Else Say ' invalid checksum digit '  z  " for "  x    '   (should be'  d")"
    End   /*j*/
  Return  /syntaxhighlight>
{{out|output|text=&nbsp; when using the (internal) default inputs:}}
<pre>
   valid checksum digit  4  for  5724
 invalid checksum digit  7  for  5727    (should be 4)
   valid checksum digit  6  for  112946
 invalid checksum digit  0  for  112940    (should be 6)
</pre>
