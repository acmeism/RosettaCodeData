/* REXX ***************************************************************
* 13.10.2013 Walter Pachl  another way to show documentation
*                          no tags and good enough if only one documentation block
**********************************************************************/
beghelp=here()+1                  /* line where the docmentation begins
Documentation
any test explaining the program's invocaion and workings
---
                                     and where it ends               */
endhelp=here()-2
If arg(1)='?' Then Do
  Do i=beghelp To endhelp
    Say sourceline(i)
    End
  Exit
  End
say 'the program would be here!'
Exit
here: return sigl            /* returns the invocation's line number */
