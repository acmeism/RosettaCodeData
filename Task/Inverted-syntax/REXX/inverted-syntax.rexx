      SIGNAL   {ON|OFF}   someCondition   {name}

/*here is an example of a special case (for SYNTAX). */
signal on syntax
a=7
zz=444/(7-a)
return zz

syntax: say '***error***!'
        say 'program is attempting to do division by zero.'
        say 'REXX statement number is:' sigL
        say 'the Rexx source statement is:'
        say sourceLine(sigL)
        exit 13
