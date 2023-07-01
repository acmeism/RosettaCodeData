/* REXX shows the "equivalent" to PL/I's PUT DATA for a simple variable */
/* put_data2('a.') to show all a.tail values isn't that easy :-)        */
j=2
abc.j= -4.12
Say put_data('abc.2')     /* Put Data(abc(2)) */
string=put_data('abc.2')  /* Put string(string) Data(abc(2)) */
Say string
Exit
put_data:
Parse Arg variable
return(variable'='''value(variable)'''')
