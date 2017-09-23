Numeric digits 1000             /*just in case the user gets ka-razy. */
Say 'enter some numbers to be summed:'
parse pull y
yplus=add_plus(y)
sum=0
Do While y<>''
  Parse Var y n y
  If datatype(n)<>'NUM' Then Do
    Say 'you entered  something that is not recognized to be a number:' n
    Exit
    End
  sum+=n
  End
Say yplus '=' sum/1
Exit
add_plus:
Parse arg list
list=space(list)
return translate(list,'+',' ')
