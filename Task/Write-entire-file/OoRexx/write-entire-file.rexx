a=.array~new                   /* create an array          */
do i=1 To 10                   /* fill the array           */
  a~append(random(100000))
  End
Say 'a~items='a~items
oid='ofile.txt'; 'erase' oid   /* define output file       */
o=.stream~new(oid)             /* create output stream     */
o~arrayout(a)                  /* wrie array to file       */
o~close                        /* close output stream      */
'type' oid                     /* show the file's contents */                .
