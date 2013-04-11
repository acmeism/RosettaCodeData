/*REXX program to generated unbiased random numbers and show results.   */
parse arg samples seed .               /*allow specification of options.*/
if samples=='' | samples==','  then samples=1000    /*SAMPLES specified?*/
if seed\==''  then call random ,,seed  /*if specified, use it for RANDOM*/
w=12                                   /*width of columnar output.      */
say   centr('N')   centr('random')   centr('unbiased')   centr('samples')

        do N=3  to 6;   b=0;   u=0
                                                do j=1  for samples
                                                b=b + randN(N)
                                                u=u + unbiased()
                                                end   /*j*/
        say  center(N,w)   center(b,w)   center(u,w)   center(samples,w)
        end     /*N*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CENTR subroutine────────────────────*/
centr: return center(arg(1),w,'─')
/*──────────────────────────────────RANDN subroutine────────────────────*/
randN: return random(1,arg(1))==arg(1)
/*──────────────────────────────────UNBIASED subroutine─────────────────*/
unbiased:     do until x\==y;   x=randN(N);   y=randN(N);  end   /*until*/
return x
