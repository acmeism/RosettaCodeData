/*REXX program checks if a number (base 10) is  self-describing         */
parse arg x y .                        /*get args from the command line.*/
if x=='' then exit                     /*if no X, then get out of Dodge.*/
if y=='' then y=x                      /*if no Y, then use the X value. */
y=min(y,999999999)
w=length(y)                            /*use Y's width for pretty output*/
/*══════════════════════════════════════test for a single number.       */
if x==y then do                        /*handle the case of a single #. */
             noYes=test_sdn(y)         /*is it  or  ain't it?           */
             say y word("is isn't",noYes+1) 'a self-describing number.'
             exit
             end
/*══════════════════════════════════════test for a range of numbers.    */
         do n=x to y
         if test_sdn(n) then iterate   /*if ¬ self-describing, try again*/
         say  right(n,w)  'is a self-describing number.'       /*is it? */
         end   /*n*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TEST_SDN subroutine─────────────────*/
test_sdn:  procedure;  parse arg ?;  if right(?,1)\==0 then return 1
return wordpos(?,'1210 2020 21200 3211000 42101000 521001000 6210001000')==0
