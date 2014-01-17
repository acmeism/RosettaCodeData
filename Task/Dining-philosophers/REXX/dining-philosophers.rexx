/*REXX prm demonstrates a solution to solve dining philosophers problem.*/
parse arg seed diners                  /*get optional arguments from CL.*/
if seed\=='' & seed\==',' then call random ,, seed   /*for repeatability*/
if diners=''              then diners='Aristotle,Kant,Spinoza,Marx,Russell'
tell=left(seed,1)\=='+'                /*Leading  +  in SEED?  No stats.*/
diners=translate(diners,,',')          /*change a commatized diners list*/
#=words(diners);   @.=0                /*the number of dining philospers*/
  eatL=15;     eatH= 60                /*min & max minutes for eating.  */
thinkL=30;   thinkH=180                /* "  "  "     "     "  thinking.*/
forks.=1                               /*indicate all forks are on table*/
             do tic=1                  /*use minutes as time advancement*/
             call grabForks            /*see if anybody can grab 2 forks*/
             call passTime             /*handle diners eating | thinking*/
             end   /*tic*/             /*  ··· and time marches on ···  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FORK subroutine─────────────────────*/
fork: parse arg x 1 ox; x=abs(x);  L=x-1; if L==0  then L=# /*boundry ? */
if ox<0  then do;  forks.L=1;  forks.x=1;  return;  end     /*drop forks*/
got2=forks.L & forks.x                 /*did we get two forks or not?   */
if got2  then do;  forks.L=0;  forks.x=0;           end     /*got forks.*/
return got2                            /*return with success or failure.*/
/*──────────────────────────────────GRABFORKS subroutine────────────────*/
grabForks:   do person=1  for  #       /*see if any person can grab two.*/
             if @.person.status\==0  then iterate  /*diner ain't waiting*/
             if \fork(person)        then iterate  /*diner didn't grab 2*/
             @.person.status='eating'  /*diner now chomps on spaghetti. */
             @.person.dur=random(eatL,eatH)  /*how long will diner eat? */
             end   /*person*/
return
/*──────────────────────────────────PASSTIME subroutine─────────────────*/
passTime:  if tell then say            /*show a (blank line) separator. */
       do p=1  for #                   /*process each diner's activity. */
       if tell  then say right(tic,9,'.')  right(word(diners,p),20),
         right(word(@.p.status 'waiting',1+(@.p.status==0)),9) right(@.p.dur,5)
       if @.p.dur==0  then iterate     /*diner is waiting for two forks.*/
       @.p.dur=@.p.dur-1               /*indicate 1 timeUnit has gone by*/
       if @.p.dur\==0 then iterate     /*Activity done?  No, keep it up.*/
         select                        /*handle the activity being done.*/
         when @.p.status=='eating' then do       /*now, leave the table.*/
                                        call fork -p   /*drop the forks.*/
                                        @.p.status='thinking'  /*status.*/
                                        @.p.dur=random(thinkL,thinkH)
                                        end
         when @.p.status=='thinking'  then @.p.status=0  /*──► table*/
         otherwise nop                 /*diner must be waiting on forks.*/
         end   /*select*/
       end     /*p*/
return
