/*REXX program finds the number of each base in a DNA  string          */
/*                                         (along with a total).       */
Parse Arg dna .
If dna==''|dna==',' Then
  dna='cgtaaaaaattacaacgtcctttggctatctcttaaactcctgctaaatg',
      'ctcgtgctttccaattatgtaagcgttccgagacggggtggtcgattctg',
      'aggacaaaggtcaagatggagcgcatcgaacgcaataaggatcatttgat',
      'gggacgtttcgtcgacaaagtcttgtttcgagagtaacggctaccgtctt',
      'cgattctgcttataacactatgttcttatgaaatggatgttctgagttgg',
      'tcagtcccaatgtgcggggtttcttttagtacgtcgggagtggtattata',
      'tttaatttttctatatagcgatctgtatttaagcaattcatttaggttat',
      'cgccgcgatgctcggttcggaccgccaagcatctggctccactgctagtg',
      'tcctaaatttgaatggcaaacacaaataagatttagcaattcgtgtagac',
      'gaccggggacttgcatgatgggagcagctttgttaaactacgaacgtaat'
dna=translate(space(dna,0))          /* elide blanks from DNA; uppercas*/
Say '--------length of the DNA string: ' length(dna)
count.=0                          /* initialize the count for all bases*/
w=1                               /* the maximum width of a base count */
names=''                          /* list of all names                 */
Do j=1 To length(dna)             /* traipse through the  DNA  string  */
  name=substr(dna,j,1)            /* obtain a base name from the DNA   */
  If pos(name,names)==0 Then
    names=names||name             /* if not found, add it to the list  */
  count.name=count.name+1         /* bump the count of this base.      */
  w=max(w,length(count.name))     /* compute the maximum number width  */
  End
Say
Do k=0 To 255
  z=d2c(k)                        /* traipse through all possibilities */
  If pos(z,names)>0 Then Do
    Say '     base ' z ' has a basecount of: ' right(count.z,w)
    count.tot=count.tot+count.z   /* add to a grand total to verify    */
    End
  End
Say
Say '--------total for all basecounts:' right(count.tot,w+1)
