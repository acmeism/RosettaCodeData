/* REXX ---------------------------------------------------------------
* 07.07.2014 Walter Pachl
* 12.07.2014 WP see Discussion where redirection from within the program is shown
*--------------------------------------------------------------------*/
Say 'rexx serr 2>err.txt directs the stderr output to the file err.txt'
Call lineout 'stderr','Good bye, world!'
Call lineout ,'Hello, world!'
Say 'and this is the error output:'
'type err.txt'
