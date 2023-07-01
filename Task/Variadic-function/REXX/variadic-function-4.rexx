/* REXX */
list=''
Do i=1 To 6
  list=list||'"arg"'i','
  End
list=list||'"end"'
Interpret 'call show' list
Exit
show:  procedure
do j=1 for arg()
  say  arg(j)
  end   /*j*/
return
