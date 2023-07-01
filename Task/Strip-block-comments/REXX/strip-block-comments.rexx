/* REXX ***************************************************************
* Split comments
* This program ignores comment delimiters within literal strings
* such as, e.g., in b = "--' O'Connor's widow --";
* it does not (yet) take care of -- comments (ignore rest of line)
* also it does not take care of say 667/*yuppers*/77 (REXX specialty)
*   courtesy GS discussion!
* 12.07.2013 Walter Pachl
**********************************************************************/
fid='in.txt'                           /* input text                 */
oic='oc.txt'; 'erase' oic              /* will contain comments      */
oip='op.txt'; 'erase' oip              /* will contain program parts */
oim='om.txt'; 'erase' oim              /* oc.txt merged with op.txt  */
cmt=0                                  /* comment nesting            */
str=''                                 /* ' or " when in a string    */
Do ri=1 By 1 While lines(fid)>0        /* loop over input            */
  l=linein(fid)                        /* an input line              */
  oc=''                                /* initialize line for oc.txt */
  op=''                                /* initialize line for op.txt */
  i=1                                  /* start at first character   */
  Do While i<=length(l)                /* loop through input line    */
    If cmt=0 Then Do                   /* we are not in a comment    */
      If str<>'' Then Do               /* we are in a string         */
        If substr(l,i,1)=str Then Do   /* string character           */
          If substr(l,i+1,1)=str Then Do /* another one              */
            Call app 'P',substr(l,i,2) /* add '' or "" to op         */
            i=i+2                      /* increase input pointer     */
            Iterate                    /* proceed in input line      */
            End
          Else Do                      /* end of literal string      */
            Call app 'P',substr(l,i,1) /* add ' or " to op           */
            str=' '                    /* no longer in string        */
            i=i+1                      /* increase input pointer     */
            Iterate                    /* proceed in input line      */
            End
          End
        End
      End
    Select
      When str='' &,                   /* not in a string            */
           substr(l,i,2)='/*' Then Do  /* start of comment           */
        cmt=cmt+1                      /* increase commenr nesting   */
        Call app 'C','/*'              /* copy to oc                 */
        i=i+2                          /* increase input pointer     */
        End
      When cmt=0 Then Do               /* not in a comment           */
        If str=' ' Then Do             /* not in a string            */
          If pos(substr(l,i,1),'''"')>0 Then /* string delimiter     */
            str=substr(l,i,1)          /* remember that              */
          End
        Call app 'P',substr(l,i,1)     /* copy to op                 */
        i=i+1                          /* increase input pointer     */
        End
      When substr(l,i,2)='*/' Then Do  /* end of comment             */
        cmt=cmt-1                      /* decrement nesting depth    */
        Call app 'C','*/'              /* copy to oc                 */
        i=i+2                          /* increase input pointer     */
        End
      Otherwise Do                     /* any other character        */
        Call app 'C',substr(l,i,1)     /* copy to oc                 */
        i=i+1                          /* increase input pointer     */
        End
      End
    End
  Call oc                              /* Write line oc              */
  Call op                              /* Write line op              */
  End
Call lineout oic                       /* Close File oic             */
Call lineout oip                       /* Close File oip             */

Do ri=1 To ri-1                        /* merge program with comments*/
  op=linein(oip)
  oc=linein(oic)
  Do i=1 To length(oc)
    If substr(oc,i,1)<>'' Then
      op=overlay(substr(oc,i,1),op,i,1)
    End
  Call lineout oim,op
  End
Call lineout oic
Call lineout oip
Call lineout oim
Exit

app: Parse Arg which,string
/* add str to oc or op                                               */
/* and corresponding blanks to the other (op or oc)                  */
If which='C' Then Do
  oc=oc||string
  op=op||copies(' ',length(string))
  End
Else Do
  op=op||string
  oc=oc||copies(' ',length(string))
  End
Return

oc: Return lineout(oic,oc)
op: Return lineout(oip,op)
