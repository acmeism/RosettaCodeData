/*REXX program to  demonstrate  how to   flatten   a list.              */

y = '[[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]'

z=translate(y,,'[,]')    /*change brackets & commas to blanks*/
z=space(z)               /*remove extraneous blanks*/
z=changestr(' ',z,", ")  /*change blanks to "comma blank"*/
z='['z"]"                /*add brackets*/

say ' input =' y
say 'output =' z
                                       /*stick a fork in it, we're done.*/
