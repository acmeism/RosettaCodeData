/*┌───────────────────────────────────────────────────────────────────┐
  │ The REXX language doesn't allow for the changing or overriding of │
  │ syntax per se,  but any of the built-in-functions (BIFs) can be   │
  │ overridden by just specifying your own.                           │
  │                                                                   │
  │ To use the REXX's version of a built-in-function, you simply just │
  │ enclose the BIF in quotation marks (and uppercase the name).      │
  │                                                                   │
  │ The intent is two-fold:  the REXX language doesn't have any       │
  │ reserved words,  nor reserved  BIFs  (Built-In-Functions).        │
  │                                                                   │
  │ So, if you don't know that  VERIFY  is a BIF,  you can just code  │
  │ a subroutine (or function)  with that name (or any name), and not │
  │ worry about your subroutine being pre-empted.                     │
  │                                                                   │
  │ Second:  if you're not satisfied how a BIF works, you can code    │
  │ your own.   This also allows you to front-end a BIF for debugging │
  │ or modifying the BIF's behavior.                                  │
  └───────────────────────────────────────────────────────────────────┘ */
yyy='123456789abcdefghi'

rrr =  substr(yyy,5)                   /*returns  efghi                 */
mmm = 'SUBSTR'(yyy,5)                  /*returns  56789abcdefgji        */
sss = "SUBSTR"(yyy,5)                  /* (same as above)               */
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────SUBSTR subroutine───────────────────*/
substr: return right(arg(1),arg(2))

/*┌───────────────────────────────────────────────────────────────────┐
  │ Also, some REXX interpreters treat whitespace(s) as blanks   when │
  │ performing comparisons.    Some of the whitespace characters are: │
  │                                                                   │
  │           NL  (newLine)                                           │
  │           FF  (formFeed)                                          │
  │           VT  (vertical tab)                                      │
  │           HT  (horizontal tab or TAB)                             │
  │           LF  (lineFeed)                                          │
  │           CR  (carriage return)                                   │
  │           EOF (end-of-file)                                       │
  │         and/or others.                                            │
  │                                                                   │
  │ Note that some of the above are ASCII or EBCDIC specific.         │
  │                                                                   │
  │ Some REXX interpreters use the   OPTIONS   statement to force     │
  │ REXX to only treat blanks as spaces.                              │
  │                                                                   │
  │ (Both the  verb  and  option  may be in lower/upper/mixed case.)  │
  │                                                                   │
  │ REXX interpreters which don't recognize any  option  won't treat  │
  │ the (below) statement as an error.                                │
  └───────────────────────────────────────────────────────────────────┘ */
options  strict_white_space_comparisons   /*can be in lower/upper/mixed.*/
