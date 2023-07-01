'dir a2.txt'
Say 'rc='rc
'dir 33.*'
Say 'rc='rc

Call square 5
Say 'RESULT='result
Say 'SIGL='sigl

x2=square(3) /* just a simle example */
Say '3**2='||x2

Signal On Novalue
x=y   /* y was not yet assigned a value */

Exit
square: Procedure Expose sigl
Say 'square was invoked from line' sigl':' sourceline(sigl)
Return arg(1)**2

Novalue:
Say 'NOVALUE encountered in line' sigl':' sourceline(sigl)
Exit
