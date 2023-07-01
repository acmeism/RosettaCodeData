/*REXX program generates values for six core attributes for a  RPG  (Role Playing Game).*/
   do  until  m>=2 & $$>=75;   $$= 0;     list=  /*do rolls until requirements are met. */
   m= 0                                          /*the number of values ≥ 15   (so far).*/
        do 6;                  $= 0              /*6 values (meet criteria); attrib. sum*/
             do d=1  for 4;    @.d= random(1, 6) /*roll four random dice (six sided die)*/
             $= $ + @.d                          /*also obtain their sum  (of die pips).*/
             end   /*d*/                         /* [↓]  use of MIN  BIF avoids sorting.*/
        $= $  -  min(@.1, @.2, @.3, @.4)         /*obtain the sum of the highest 3 rolls*/
        list= list  $;         $$= $$ + $        /*append $──►list; add $ to overall $$.*/
        $$= $$ + $                               /*add the  $  sum  to the overall sum. */
        m= m + ($>=15)                           /*get # of rolls that meet the minimum.*/
        end       /*do 6*/                       /* [↑]  gen six core attribute values. */
   end            /*until*/                      /*stick a fork in it,  we're all done. */
say 'The total for '     list      "  is ──► "       $$', '     m     " entries are ≥ 15."
