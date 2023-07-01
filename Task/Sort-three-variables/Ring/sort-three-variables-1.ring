# Project : Sort three variables

x = 'lions, tigers, and'
y = 'bears, oh my!'
z = '(from the "Wizard of OZ")'
sortthree(x,y,z)
x = 77444
y = -12
z = 0
sortthree(x,y,z)

func sortthree(x,y,z)
        str = []
        add(str,x)
        add(str,y)
        add(str,z)
        str = sort(str)
        see "x = " + str[1] + nl
        see "y = " + str[2] + nl
        see "z = " + str[3] + nl
        see nl
