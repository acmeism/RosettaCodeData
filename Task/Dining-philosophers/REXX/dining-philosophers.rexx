/*REXX pgm demonstrates a solution in solving the dining philosophers problem.*/
signal on halt                         /*branches to  HALT:   (on Ctrl─break).*/
parse arg seed diners                  /*obtain optional arguments from the CL*/
if datatype(seed,'W')  then call random ,, seed    /*for random repeatability.*/
if diners=''           then diners = 'Aristotle, Kant, Spinoza, Marx, Russell'
  tell=(left(seed,1)\=='+')            /*Leading + in SEED? Then no statistics*/
diners=space(translate(diners,,','))   /*change to an uncommatized diners list*/
     #=words(diners);      @.=  0      /*#: the number of dining philosophers.*/
  eatL=15;               eatH= 60      /*minimum & maximum minutes for eating.*/
thinkL=30;             thinkH=180      /*   "    "    "       "     " thinking*/
forks.=1                               /*indicate that all forks are on table.*/
         do tic=1   /*'til halted.*/   /*use  "minutes"  for time advancement.*/
         call grabForks                /*determine if anybody can grab 2 forks*/
         call passTime                 /*handle philosophers eating|thinking. */
         end   /*tic*/                 /*     ··· and time marches on ···     */
                                       /* [↓]    this REXX program was halted,*/
halt: say '  ··· REXX program halted!' /*probably by Ctrl─Break or equivalent.*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────FORK subroutine───────────────────────────*/
fork: parse arg x 1 ox; x=abs(x);  L=x-1; if L==0  then L=#  /*on a boundary? */
if ox<0  then do;  forks.L=1;  forks.x=1;  return;  end      /*drop the forks.*/
got2=forks.L & forks.x                                       /*get 2 forks │ ¬*/
if got2  then do;  forks.L=0;  forks.x=0;           end      /*got two forks. */
return got2                            /*return with success  ··· or failure. */
/*──────────────────────────────────GRABFORKS subroutine──────────────────────*/
grabForks:  do person=1  for  #        /*see if any person can grab two forks.*/
            if @.person.state\==0  then iterate    /*the diner ain't waiting. */
            if \fork(person)       then iterate    /*the diner didn't grab 2. */
            @.person.state= 'eating'               /*diner spaghetti slurping.*/
            @.person.dur=random(eatL,eatH)         /*how long will diner eat? */
            end   /*person*/                       /* [↑]  handle all diners. */
return
/*──────────────────────────────────PASSTIME subroutine───────────────────────*/
passTime:      if tell  then say       /*display a handy blank line separator.*/
       do p=1  for #                   /*handle each of the diner's activity. */
       if tell  then say  right(tic,9,.)     right(word(diners,p),20),
          right(word(@.p.state 'waiting', 1+(@.p.state==0)),9)  right(@.p.dur,5)
       if @.p.dur==0   then iterate    /*this diner is waiting for two forks. */
       @.p.dur=@.p.dur - 1             /*indicate single time unit has passed.*/
       if @.p.dur\==0  then iterate    /*Activity done?   No, then keep it up.*/
       if @.p.state=='eating'  then do                 /*now, leave the table.*/
                                    call fork  -p      /*drop the darn forks. */
                                    @.p.state='thinking'             /*status.*/
                                    @.p.dur=random(thinkL,thinkH)    /*length.*/
                                    end           /* [↓]  diner ──► the table.*/
                               else if  @.p.state=='thinking'  then @.p.state=0
       end   /*p*/                     /*[↑]  P (person) ≡dining philosophers.*/
return
