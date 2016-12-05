> slsh<Enter>
slsh version 0.9.1-2; S-Lang version: pre2.3.1-23
Copyright (C) 2005-2014 John E. Davis <jed@jedsoft.org>
This is free software with ABSOLUTELY NO WARRANTY.

slsh> define f(s1, s2, sep) {<Enter>
       return(strcat(s1, sep, sep, s2));<Enter>
       }<Enter>
slsh> f("Rosetta", "Code", ":");<Enter>
Rosetta::Code
slsh> quit<Enter>
>
