/*REXX program finds words with the largest set of anagrams (same size)
* 07.08.2013 Walter Pachl
* sorta for word compression courtesy Gerard Schildberger,
*                            modified, however, to obey lowercase
* 10.08.2013 Walter Pachl take care of mixed case dictionary
*                         following Version 1's method
**********************************************************************/
Parse Value 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z',
       With  a b c d e f g h i j k l m n o p q r s t u v w x y z
Call time 'R'
ifid='unixdict.txt'              /* input file identifier          */
words=0                          /* number of usable words         */
maxl=0                           /* maximum number of anagrams     */
wl.=''                           /* wl.ws words that have ws       */
Do ri=1 By 1 While lines(ifid)\==0 /* read each word in file       */
  word=space(linein(ifid),0)     /* pick off a word from the input.*/
  If length(word)<3 Then         /* onesies and twosies can't win. */
    Iterate
  If\datatype(word,'M') Then     /* not an anagramable word        */
    Iterate
  words=words+1                  /* count of (useable) words.      */
  ws=sorta(word)                 /* sort the letters in the word.  */
  wl.ws=wl.ws word               /* add word to list of ws         */
  wln=words(wl.ws)               /* number of anagrams with ws     */
  Select
    When wln>maxl Then Do        /* a new maximum                  */
      maxl=wln                   /* use this                       */
      wsl=ws                     /* list of resulting ws values    */
      End
    When wln=maxl Then           /* same as the one found          */
      wsl=wsl ws                 /* add ws to the list             */
    Otherwise                    /* shorter                        */
      Nop                        /* not yet of interest            */
    End
  End
Say ' '
Say copies('-',10) ri-1 'words in the dictionary file: ' ifid
Say copies(' ',10) words 'thereof are anagram candidates'
Say ' '
Say 'There are' words(wsl) 'set(s) of anagrams with' maxl,
                                                       'elements each:'
Say ' '
Do while wsl<>''
  Parse Var wsl ws wsl
  Say '    'wl.ws
  End
Say time('E')
Exit
sorta:
/**********************************************************************
* sort the characters in word_p (lowercase translated to uppercase)
* 'chARa' -> 'AACHR'
**********************************************************************/
  Parse Upper Arg word_p
  c.=''
  Do While word_p>''
    Parse Var word_p cc +1 word_p
    c.cc=c.cc||cc
    End
  Return c.a||c.b||c.c||c.d||c.e||c.f||c.g||c.h||c.i||c.j||c.k||c.l||,
  c.m||c.n||c.o||c.p||c.q||c.r||c.s||c.t||c.u||c.v||c.w||c.x||c.y||c.z
