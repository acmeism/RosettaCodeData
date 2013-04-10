/*REXX:  how to assign an empty string & then check for empty/not-empty.*/

/*─────────────── 3 simple wats to assign an empty string to a variable.*/
auk=''               /*uses two single quotes or apostrophies.          */
ide=""               /*uses two quotes, sometimes called a double quote.*/
doe=                 /*... nothing at all.                              */

/*─────────────── assigning multiple null values to vars, 2 methods are:*/
ram=0
parse var ram . emu pug yak nit moa owl pas jay koi ern ewe fae gar hob
             /*where the value of zero is skipped, the rest set to null,*/
             /*which is the next value AFTER the value of RAM (nothing).*/

             /*───or─── (with less clutter ─── or more, ... perception).*/
parse value 0 with . ant ape ant imp fly tui paa elo dab cub bat ayu
             /*where the value of zero is skipped, the rest set to null,*/
             /*which is the next value AFTER the 0 (zero):     nothing. */

/*─────────────── how to check that a string is empty, several methods: */
if cat==''        then say "the feline is not here."
if pig==""        then say 'no ham today'
if length(gnu)==0 then say "the wildebeast is empty & hungry."
if length(ips)=0  then say "checking with   ==   instead of  =  is faster"
if length(hub)<1  then method = "obtuse, don't do as I do ..."

nit=''                           /*assign an empty string to a lice egg.*/
if cow==nit       then say 'the cow has no milk today.'

/*─────────────── how to check that a string isn't empty, several ways: */
if dog\==''        then say "the dogs are out!"
                            /*most REXXes support the "not" character.  */
if fox¬==''        then say "and the fox is in the henhouse."
if length(rat)>0   then say "the rat is singing"     /*ugly way to test.*/

if elk==''         then nop; else say "long way for an elk to be tested."

if length(eel)\==0 then fish=eel                  /*fast compare, quick.*/
if length(cod)\=0  then fish=cod                  /*not-so-fast compare.*/

/*────────────────────────── anyway, as they say: "choose your poison." */
