/*REXX pgm executes a Turing machine based on initial state, tape, rules*/
state = 'q0'                           /*initial Turing machine state.  */
term  = 'qf'                           /*a state that is used for halt. */
blank = 'B'                            /*this character is a true blank.*/
call turing_rule  'q0 1 1 right q0'    /*define a rule for the machine. */
call turing_rule  'q0 B 1 stay  qf'    /*   "   "   "   "   "     "     */
call turing_init   1 1 1               /*initialize tape to string(s).  */
call turing_machine                    /*go invoke the Turning machine. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TURING_MACHINE subroutine───────────*/
turing_machine:  !=1;  bot=1;  top=1   /*start at the tape location  1. */
say                                    /*might as well show a blank line*/
     do cycle=1  until  state==term    /*do Turing machine instructions.*/
        do k=1  for rules              /*process the Turning mach. rules*/
        parse var rule.k rState rTape rWrite rMove rNext . /*pick pieces*/
        if state\==rState | @.!\==rTape  then iterate      /*wrong rule?*/
        @.!=rWrite                     /*right rule;  write it ──► tape.*/
        if rMove== 'left'  then !=!-1  /*Move left?   Then subtract one.*/
        if rMove=='right'  then !=!+1  /*Move right?  Then   add    one.*/
        bot=min(bot,!); top=max(top,!) /*find the  tape  bottom and top.*/
        state=rNext                    /*use this for the next  state.  */
        iterate cycle                  /*go process another instruction.*/
        end   /*k*/
     say '***error!*** unknown state:'  state;     leave         /*oops.*/
     end   /*cycle*/
$=                                     /*start with empty string (tape).*/
     do t=bot  to top;   _=@.t;    if _==blank  then _=' '  /*translate?*/
     $=$ || pad || _                   /*build chr by chr, maybe pad it.*/
     end   /*t*/                       /* [↑] build the tape's contents.*/
if $=''  then $= "[tape is blank.]"    /*make an   empty tape   visible.*/
say 'Turning machine used'  rules  "rules in"  cycle  'cycles, tape is:' $
return
/*──────────────────────────────────TURING_INIT subroutine──────────────*/
turing_init:  @.=blank;                parse arg x
              do j=1  for words(x);    @.j=word(x,j);         end  /*j*/
return
/*──────────────────────────────────TURING_RULE subroutine──────────────*/
turing_rule:  if symbol('RULES')=="LIT"  then rules=0;       rules=rules+1
pad=left('',length(word(arg(1),2))\==1) /*used if any symbol's length>1.*/
rule.rules=arg(1);      say right('rule' rules,20)    "═══►"    rule.rules
return
