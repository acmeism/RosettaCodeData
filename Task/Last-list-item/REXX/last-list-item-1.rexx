/* REXX */
List = '6 81 243 14 25 49 123 69 11'
Do Until words(list)=1
  list=wordsort(list)
  Say 'Sorted list:' list
  Parse Var list a b c
  Say 'Two smallest:' a '+' b '=' (a+b)
  list=(a+b) c
  End
Say 'Last item:' list
Exit
wordsort: Procedure
/**********************************************************************
* Sort the list of words supplied as argument. Return the sorted list
**********************************************************************/
  Parse Arg wl
  wa.=''
  wa.0=0
  Do While wl<>''
    Parse Var wl w wl
    Do i=1 To wa.0
      If wa.i>w Then Leave
      End
    If i<=wa.0 Then Do
      Do j=wa.0 To i By -1
        ii=j+1
        wa.ii=wa.j
        End
      End
    wa.i=w
    wa.0=wa.0+1
    End
  swl=''
  Do i=1 To wa.0
    swl=swl wa.i
    End
  Return strip(swl)
