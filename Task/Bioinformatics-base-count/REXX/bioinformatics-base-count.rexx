/*REXX program finds the number of each  base  in a  DNA  string  (along with a total). */
parse arg dna .
if dna==''   | dna==","  then dna= 'cgtaaaaaattacaacgtcctttggctatctcttaaactcctgctaaatg'  ,
                                   'ctcgtgctttccaattatgtaagcgttccgagacggggtggtcgattctg'  ,
                                   'aggacaaaggtcaagatggagcgcatcgaacgcaataaggatcatttgat'  ,
                                   'gggacgtttcgtcgacaaagtcttgtttcgagagtaacggctaccgtctt'  ,
                                   'cgattctgcttataacactatgttcttatgaaatggatgttctgagttgg'  ,
                                   'tcagtcccaatgtgcggggtttcttttagtacgtcgggagtggtattata'  ,
                                   'tttaatttttctatatagcgatctgtatttaagcaattcatttaggttat'  ,
                                   'cgccgcgatgctcggttcggaccgccaagcatctggctccactgctagtg'  ,
                                   'tcctaaatttgaatggcaaacacaaataagatttagcaattcgtgtagac'  ,
                                   'gaccggggacttgcatgatgggagcagctttgttaaactacgaacgtaat'
dna= space(dna, 0);  upper dna                   /*elide blanks from DNA; uppercase it. */
say '────────length of the DNA string: '   length(dna)
@.= 0                                            /*initialize the count for all bases.  */
w= 1                                             /*the maximum width of a base count.   */
$=                                               /*a placeholder for the names of bases.*/
       do j=1  for length(dna)                   /*traipse through the  DNA  string.    */
       _= substr(dna, j, 1)                      /*obtain a base name from the DNA str. */
       if pos(_, $)==0  then $= $  ||  _         /*if not found before, add it to list. */
       @._= @._ + 1                              /*bump the count of this base.         */
       w= max(w, length(@._) )                   /*compute the maximum width number.    */
       end   /*j*/
say
       do k=0  for 255;   z= d2c(k)              /*traipse through all possibilities.   */
       if pos(z, $)==0  then iterate             /*Was this base found?  No, then skip. */
       say '     base '   z    " has a basecount of: "   right(@.z, w)
       @.tot= @.tot + @.z                        /*add to a grand total to verify count.*/
       end   /*k*/                               /*stick a fork in it,  we're all done. */
say
say '────────total for all basecounts:'                  right(@.tot, w+1)
