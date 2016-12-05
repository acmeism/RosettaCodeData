/*REXX program sounds "ship's bells"  (using PC speaker)  when executing  (perpetually).*/
echo= (arg()\==0)                                /*echo time and bells if any arguments.*/
signal on halt                                   /*allow a clean way to stop the program*/
                   t.1=  '00:30   01:00   01:30   02:00   02:30   03:00   03:30   04:00'
                   t.2=  '04:30   05:00   05:30   06:00   06:30   07:00   07:30   08:00'
                   t.3=  '08:30   09:00   09:30   10:00   10:30   11:00   11:30   12:00'

      do forever;  t=time();  ss=right(t,2);  mn=substr(t,4,2)      /*the current time. */
      ct=time('C')                               /*[↓]  maybe add leading zero*/
      hhmmc=left( right( ct, 7, 0),  5)          /*HH:MM  (with leading zero).*/
      if echo  then say center(arg(1) ct, 79)    /*echo 1st arg with the time?*/
      if ss\==00 & mn\==00 & mn\==30  then do    /*wait for the next minute ? */
                                           call delay 60-ss;    iterate
                                           end   /* [↑]  delay minute fraction*/
                                                 /* [↓]  number bells to peel.*/
                       do j=1  for 3  until $\==0;   $=wordpos(hhmmc,t.j)
                       end   /*j*/

      if $\==0 & echo  then say center($ "bells", 79)               /*echo the bells ?  */

                       do k=1 for $;  call sound 650,1;  call delay 1 +(k//2==0)
                       end   /*k*/               /*[↑]   peel and then pause. */
      call delay 60                              /*ensure we don't re-peel.   */
      end   /*forever*/
halt:                                            /*stick a fork in it,  we're all done. */
