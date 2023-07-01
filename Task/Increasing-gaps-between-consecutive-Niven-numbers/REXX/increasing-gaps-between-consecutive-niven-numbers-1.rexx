/*REXX program finds and displays the largest gap between  Niven  numbers (up to LIMIT).*/
parse arg lim .                                  /*obtain optional arguments from the CL*/
if lim=='' | lim==','  then lim= 10000000        /*Not specified?  Then use the default.*/
numeric digits 2 + max(8, length(lim) )          /*enable the use of any sized numbers. */
gap= 0;                     old= 0               /*initialize (largest) gap; old Niven #*/
                                              @gsa= 'gap starts at Niven #'
call tell center('gap size', 12)       center(@gsa "index", 29)          center(@gsa, 29)
call tell copies('═'       , 12)       copies('═'         , 29)          copies('═' , 29)
#= 0                                             /*#:  is the index of a Niven number.  */
    do n=1                                       /*◄───── let's go Niven number hunting.*/
    parse var  n  1  sum  2  q                   /*use the first decimal digit for  SUM.*/
                 do  while  q\=='';    parse var q x 2 q;          sum= sum + x
                 end   /*while*/                 /*    ↑                                */
    if n//sum >0  then iterate                   /*    └──────◄ is destructively parsed.*/
    #= # + 1                                     /*bump the  index  of the Niven number.*/
    if n-old<=gap  then do; old= n; iterate; end /*Is gap not bigger?  Then keep looking*/
    gap= n - old;           old= n               /*We found a bigger gap; define new gap*/
    idx= max(1, #-1);       san= max(1, n-gap)   /*handle special case of the first gap.*/
    call tell right(commas(gap),  7)left('', 5), /*center right─justified Niven gap size*/
              right(commas(idx), 25)left('', 4), /*   "     "       "     Niven num idx.*/
              right(commas(san), 25)             /*   "     "       "       "   number. */
    if n >= lim  then leave                      /*have we exceeded the (huge)  LIMit ? */
    end   /*n*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do c=length(_)-3  to 1  by -3; _=insert(',', _, c); end;   return _
tell:    say arg(1);   return
