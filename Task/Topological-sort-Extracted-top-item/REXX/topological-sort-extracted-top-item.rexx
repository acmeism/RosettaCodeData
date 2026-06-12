/*REXX program  displays the  compile  order  of jobs  (indicating the dependencies).   */
parse arg job                                    /*obtain optional argument from the CL.*/
jobL.=;   stage.=;    #.=0;      @.=;       JL=  /*define some handy─dandy variables.   */
tree.=;                      tree.1= '  top1     des1      ip1       ip2                 '
                             tree.2= '  top2     des1      ip2       ip3                 '
                             tree.3= '  ip1      extra1    ip1a      ipcommon            '
                             tree.4= '  ip2      ip2a      ip2b      ip2c       ipcommon '
                             tree.5= '  des1     des1a     des1b     des1c               '
                             tree.6= '  des1a    des1a1    des1a2                        '
                             tree.7= '  des1c    des1c1    extra1                        '
$=
              do j=1  while  tree.j\==''                               /*build job tree.*/
              parse var tree.j x deps;           @.x= space(deps)      /*extract jobs.  */
              if wordpos(x, $)==0  then $= $ x                         /*Unique? Add it.*/
                       do k=1  for words(@.x);   _= word(@.x, k)
                       if wordpos(_, $)==0  then $= space($ _)
                       end   /*k*/
              end            /*j*/
!.=;  !!.= !.                                                          /*init. 2 arrays.*/
              do j=1      for words($);          x= word($, j);        !.x.0= words(@.x)
                  do k=1  for !.x.0;         !.x.k= word(@.x, k);     !!.x.k= !.x.k
                  end   /*k*/                    /* [↑]  build arrays of job departments*/
              end       /*j*/

  do words($)                                    /*process all the jobs specified.      */
      do j=1  for words($);      x= word($, j);     z= words(@.x);      allN= 1;      m= 0
      if z==0  then do;  #.x=1;  iterate;  end   /*if no dependents, then skip this one.*/
         do k=1  for z;          y= !.x.k        /*examine all the stage numbers.       */
         if datatype(y, 'W')  then m= max(m, y)  /*find the highest stage number.       */
                              else do;  allN= 0  /*at least one entry isn't  numeric.   */
                                        if #.y\==0  then !.x.k= #.y
                                   end           /* [↑]  replace with a number.         */
         end   /*k*/
      if allN & m\==0  then #.x= max(#.x, m + 1) /*replace with the stage number max.   */
      end      /*j*/                             /* [↑]  maybe set the stage number.    */
  end          /*words($)*/

if job=''  then job= word(tree.1, 1)             /*Not specified?   Use 1st job in tree.*/
jobL.1= job                                      /*define the bottom level jobList.     */
s= 1                                             /*define the stage level for jobList.  */
        do j=1;              yyy= jobL.j
           do r=1  for words(yyy)                /*verify that there are no duplicates. */
               do c=1  while c<words(yyy);                    z= word(yyy,c)
               p= wordpos(z, yyy, c + 1);    if p\==0  then yyy= delword(yyy, p, 1)
               end   /*c*/                       /* [↑]   Duplicate?    Then delete it. */
           end       /*r*/
        jobL.j= yyy
        if yyy=''  then leave                    /*if null, then we're done with jobList*/
        z= words(yyy)                            /*number of jobs in the jobList.       */
        s= s+1                                   /*bump the stage number.               */
               do k=1  for z;    _= word(yyy, k) /*obtain a stage number for the job.   */
               jobL.s= jobL.s  @._               /*add a job to a stage.                */
               end   /*k*/
        end          /*j*/

   do k=1  for s;   JL= JL jobL.k                /*build a complete jobList  (JL).      */
   end   /*k*/

   do s=1  for words(JL);        _= word(JL, s)  /*process each job in the  jobList.    */
   level= #._                                    /*get the proper level for the job.    */
   stage.level= stage.level _                    /*assign a level to job stage number.  */
   end   /*s*/                                   /* [↑]  construct various job stages.  */

say '───────  The compile order for job: '       job        " ────────";              say
                                                 /* [↓]  display the stages for the job.*/
   do show=1  for s;     if stage.show\==''  then say show stage.show
   end   /*show*/                                /*stick a fork in it,  we're all done. */
