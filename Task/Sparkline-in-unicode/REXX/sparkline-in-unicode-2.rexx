/*REXX program displays a sparkline (spark graph) for a group of values.*/
if arg()==0  then do                   /*No arguments?     Use defaults.*/
                  call sparkGraph  1 2 3 4 5 6 7 8 7 6 5 4 3 2 1
                  call sparkGraph '1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5'
                  end
             else call sparkGraph arg(1)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CEIL subroutine─────────────────────*/
ceil: procedure;  parse arg ?;         _=trunc(?);   return _+(?>0)*(?\=_)
/*──────────────────────────────────SPARKGRAPH subroutine───────────────*/
sparkGraph: procedure;  parse arg x;   say ' input: '  x   /*echo values*/
x=translate(x, ' ', ",")               /*remove any superfluous commas. */
$='▁▂▃▄▅▆▇█'                       /*chars to be used for the graph.*/
xmin=word(x,1);  xmax=xmin             /*assume a minimum and a maximum.*/

    do n=2  to words(x);  _=word(x,n)  /*examine successive words in  X.*/
    xmin=min(_,xmin)                   /*find the minimum value in  X.  */
    xmax=max(_,xmax)                   /*  "   "  maximum   "    "  "   */
    end   /*n*/

z=;      do j=1  for words(x)          /*build the output spark graph.  */
         z=z||substr($,ceil((word(x,j)-xmin+1)/(xmax-xmin+1)*length($)),1)
         end   /*j*/

say 'output: '   z;   say              /*show the output, + a blank line*/
return
