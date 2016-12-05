/*REXX program  demonstrates  Soundex codes  from some words  or  from the command line.*/
_=;   @.=                                        /*set a couple of vars to "null".*/
parse arg @.0 .                                  /*allow input from command line. */
                           @.1   = "12346"         ;        #.1   = '0000'
                           @.4   = "4-H"           ;        #.4   = 'H000'
                           @.11  = "Ashcraft"      ;        #.11  = 'A261'
                           @.12  = "Ashcroft"      ;        #.12  = 'A261'
                           @.18  = "auerbach"      ;        #.18  = 'A612'
                           @.20  = "Baragwanath"   ;        #.20  = 'B625'
                           @.22  = "bar"           ;        #.22  = 'B600'
                           @.23  = "barre"         ;        #.23  = 'B600'
                           @.20  = "Baragwanath"   ;        #.20  = 'B625'
                           @.28  = "Burroughs"     ;        #.28  = 'B620'
                           @.29  = "Burrows"       ;        #.29  = 'B620'
                           @.30  = "C.I.A."        ;        #.30  = 'C000'
                           @.37  = "coöp"          ;        #.37  = 'C100'
                           @.43  = "D-day"         ;        #.43  = 'D000'
                           @.44  = "d jay"         ;        #.44  = 'D200'
                           @.45  = "de la Rosa"    ;        #.45  = 'D462'
                           @.46  = "Donnell"       ;        #.46  = 'D540'
                           @.47  = "Dracula"       ;        #.47  = 'D624'
                           @.48  = "Drakula"       ;        #.48  = 'D624'
                           @.49  = "Du Pont"       ;        #.49  = 'D153'
                           @.50  = "Ekzampul"      ;        #.50  = 'E251'
                           @.51  = "example"       ;        #.51  = 'E251'
                           @.55  = "Ellery"        ;        #.55  = 'E460'
                           @.59  = "Euler"         ;        #.59  = 'E460'
                           @.60  = "F.B.I."        ;        #.60  = 'F000'
                           @.70  = "Gauss"         ;        #.70  = 'G200'
                           @.71  = "Ghosh"         ;        #.71  = 'G200'
                           @.72  = "Gutierrez"     ;        #.72  = 'G362'
                           @.80  = "he"            ;        #.80  = 'H000'
                           @.81  = "Heilbronn"     ;        #.81  = 'H416'
                           @.84  = "Hilbert"       ;        #.84  = 'H416'
                           @.100 = "Jackson"       ;        #.100 = 'J250'
                           @.104 = "Johnny"        ;        #.104 = 'J500'
                           @.105 = "Jonny"         ;        #.105 = 'J500'
                           @.110 = "Kant"          ;        #.110 = 'K530'
                           @.116 = "Knuth"         ;        #.116 = 'K530'
                           @.120 = "Ladd"          ;        #.120 = 'L300'
                           @.124 = "Llyod"         ;        #.124 = 'L300'
                           @.125 = "Lee"           ;        #.125 = 'L000'
                           @.126 = "Lissajous"     ;        #.126 = 'L222'
                           @.128 = "Lukasiewicz"   ;        #.128 = 'L222'
                           @.130 = "naïve"         ;        #.130 = 'N100'
                           @.141 = "Miller"        ;        #.141 = 'M460'
                           @.143 = "Moses"         ;        #.143 = 'M220'
                           @.146 = "Moskowitz"     ;        #.146 = 'M232'
                           @.147 = "Moskovitz"     ;        #.147 = 'M213'
                           @.150 = "O'Conner"      ;        #.150 = 'O256'
                           @.151 = "O'Connor"      ;        #.151 = 'O256'
                           @.152 = "O'Hara"        ;        #.152 = 'O600'
                           @.153 = "O'Mally"       ;        #.153 = 'O540'
                           @.161 = "Peters"        ;        #.161 = 'P362'
                           @.162 = "Peterson"      ;        #.162 = 'P362'
                           @.165 = "Pfister"       ;        #.165 = 'P236'
                           @.180 = "R2-D2"         ;        #.180 = 'R300'
                           @.182 = "rÄ≈sumÅ∙"      ;        #.182 = 'R250'
                           @.184 = "Robert"        ;        #.184 = 'R163'
                           @.185 = "Rupert"        ;        #.185 = 'R163'
                           @.187 = "Rubin"         ;        #.187 = 'R150'
                           @.191 = "Soundex"       ;        #.191 = 'S532'
                           @.192 = "sownteks"      ;        #.192 = 'S532'
                           @.199 = "Swhgler"       ;        #.199 = 'S460'
                           @.202 = "'til"          ;        #.202 = 'T400'
                           @.208 = "Tymczak"       ;        #.208 = 'T522'
                           @.216 = "Uhrbach"       ;        #.216 = 'U612'
                           @.221 = "Van de Graaff" ;        #.221 = 'V532'
                           @.222 = "VanDeusen"     ;        #.222 = 'V532'
                           @.230 = "Washington"    ;        #.230 = 'W252'
                           @.233 = "Wheaton"       ;        #.233 = 'W350'
                           @.234 = "Williams"      ;        #.234 = 'W452'
                           @.236 = "Woolcock"      ;        #.236 = 'W422'

      do k=0  for 300;     if @.k==''  then iterate;        $=soundex(@.k)
      say word('nope [ok]', 1 +($==#.k | k==0))   _   $   "is the Soundex for"   @.k
      if k==0  then leave
      end   /*k*/
exit                                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
soundex: procedure;     arg x                             /*ARG uppercases the var   X. */
         old_alphabet= 'AEIOUYHWBFPVCGJKQSXZDTLMNR'
         new_alphabet= '@@@@@@**111122222222334556'
         word=                                            /* [+]  exclude  non-letters. */
                do i=1  for length(x);  _=substr(x, i, 1) /*obtain a character from word*/
                if datatype(_,'M')  then word=word || _   /*Upper/lower letter?  Then OK*/
                end   /*i*/

         value=strip(left(word, 1))                       /*1st character is left alone.*/
         word=translate(word, new_alphabet, old_alphabet) /*define the current  word.   */
         prev=translate(value,new_alphabet, old_alphabet) /*   "    "  previous   "     */

           do j=2  to length(word)                        /*process remainder of word.  */
           ?=substr(word, j, 1)
           if ?\==prev & datatype(?,'W')  then do;  value=value || ?;  prev=?;  end
                                          else if ?=='@'  then prev=?
           end   /*j*/

         return left(value,4,0)                           /*padded value with zeroes.   */
