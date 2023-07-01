/*REXX program acts as a host and allows two or more people to play the   WORDIFF  game.*/
signal on halt                                   /*allow the user(s) to halt the game.  */
parse arg iFID seed .                            /*obtain optional arguments from the CL*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /*Not specified?  Then use the default.*/
if datatype(seed, 'W')  then call random ,,seed  /*If      "         "   "   "    seed. */
call read
call IDs
first= random(1, min(100000, starters) )         /*get a random start word for the game.*/
list= $$$.first
say;                say eye  "OK, let's play the  WORDIFF  game.";   say;   say
         do round=1
                    do player=1  for players
                    call show;   ou= o;   upper ou
                    call CBLF  word(names, player)
                    end   /*players*/
         end              /*round*/

halt: say;  say;  say eye 'The  WORDIFF  game has been halted.'
done: exit 0                                     /*stick a fork in it,  we're all done. */
quit: say;  say;  say eye 'The  WORDDIF  game is quitting.';   signal done
/*──────────────────────────────────────────────────────────────────────────────────────*/
isMix: return datatype(arg(1), 'M')              /*return unity if arg has mixed letters*/
ser:   say;   say eye '***error*** ' arg(1).;   say;    return  /*issue error message.  */
last:  parse arg y;      return word(y, words(y) )              /*get last word in list.*/
over:  call ser 'word ' _ x _ arg(1);  say eye 'game over,' you; signal done /*game over*/
show:  o= last(list);   say;  call what;  say;   L= length(o);    return
verE:  m= 0;  do v=1  for L; m= m + (substr(ou,v,1)==substr(xu,v,1)); end;   return m==L-1
verL:  do v=1  for L;  if space(overlay(' ', ou, v), 0)==xu  then return 1; end;  return 0
verG:  do v=1  for w;  if space(overlay(' ', xu, v), 0)==ou  then return 1; end;  return 0
what:  say eye 'The current word in play is: '   _   o   _;       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
CBLF:  parse arg you                             /*ask carbon-based life form for a word*/
          do getword=0  by 0  until x\==''
          say eye "What's your word to be played, " you'?'
          parse pull x;  x= space(x);   #= words(x);  if #==0  then iterate;  w= length(x)
          if #>1  then do;  call ser 'too many words given: '   x
                            x=;  iterate getword
                       end
          if \isMix(x)  then do;  call ser 'the name'   _  x  _  " isn't alphabetic"
                                  x=;   iterate getword
                             end
          end   /*getword*/

       if wordpos(x, list)>0  then call over " has already been used"
       xu= x;  upper xu                          /*obtain an uppercase version of word. */
       if \@.xu  then call over  " doesn't exist in the dictionary: " iFID
       if length(x) <3            then call over  " must be at least three letters long."
       if w <L  then  if \verL()  then call over  " isn't a legal letter deletion."
       if w==L  then  if \verE()  then call over  " isn't a legal letter substitution."
       if w >L  then  if \verG()  then call over  " isn't a legal letter addition."
       list= list  x                             /*add word to the list of words used.  */
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
IDs:   ?= "Enter the names of the people that'll be playing the WORDIFF game   (or Quit):"
       names=                                    /*start with a clean slate (of names). */
          do getIDs=0  by 0  until words(names)>1
          say;  say eye ?
          parse pull ids;  ids= space( translate(ids, , ',') )      /*elide any commas. */
          if ids==''  then iterate;  q= ids;  upper q               /*use uppercase QUIT*/
          if abbrev('QUIT', q, 1)  then signal quit
            do j=1  for words(ids);    x= word(ids, j)
            if \isMix(x)  then do;  call ser 'the name'    _ x _  " isn't alphabetic"
                                    names=;   iterate getIDs
                               end
            if wordpos(x, names)>0  then do; call ser 'the name' _ x _ " is already taken"
                                             names=;   iterate getIDs
                                         end
            names= space(names x)
            end   /*j*/
          end     /*getIDs*/
       say
       players= words(names)
          do until ans\==''
          say eye 'The '    players     " player's names are: "    names
          say eye 'Is this correct?';   pull ans;  ans= space(ans)
          end   /*until*/
       yeahs= 'yah yeah yes ja oui si da';   upper yeahs
          do ya=1  for words(yeahs)
          if abbrev( word(yeahs, ya), ans, 2) | ans=='Y'  then return
          end   /*ya*/
       call IDS;                                               return
/*──────────────────────────────────────────────────────────────────────────────────────*/
read: _= '───';       eye= copies('─', 8)        /*define a couple of eye catchers.     */
      say;   say eye eye eye  'Welcome to the  WORDIFF  word game.'  eye eye eye;    say
      @.= 0;           starters= 0
            do r=1  while lines(iFID)\==0        /*read each word in the file  (word=X).*/
            x= strip(linein(iFID))               /*pick off a word from the input line. */
            if \isMix(x)  then iterate           /*Not a suitable word for WORDIFF? Skip*/
            y= x;    upper x                     /*pick off a word from the input line. */
            @.x= 1;  L= length(x)                /*set a semaphore for uppercased word. */
            if L<3 | L>4  then iterate           /*only use short words for the start.  */
            starters= starters + 1               /*bump the count of starter words.     */
            $$$.starters= y                      /*save short words for the starter word*/
            end   /*#*/
      if r>100  &  starters> 10  then return     /*is the dictionary satisfactory ?     */
      call ser 'Dictionary file ' _ iFID _ "wasn't found or isn't satisfactory.";  exit 13
