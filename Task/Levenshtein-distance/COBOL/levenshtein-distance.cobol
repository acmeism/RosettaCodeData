       identification division.
       program-id. Levenshtein.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       77  string-a               pic x(255).
       77  string-b               pic x(255).
       77  length-a               pic 9(3).
       77  length-b               pic 9(3).
       77  distance               pic z(3).
       77  i                      pic 9(3).
       77  j                      pic 9(3).
       01  tab.
           05 filler              occurs 256.
              10 filler           occurs 256.
                 15 costs         pic 9(3).

       procedure division.
       main.
           move "kitten" to string-a
           move "sitting" to string-b
           perform levenshtein-dist

           move "rosettacode" to string-a
           move "raisethysword" to string-b
           perform levenshtein-dist
           stop run
           .
       levenshtein-dist.
           move length(trim(string-a)) to length-a
           move length(trim(string-b)) to length-b

           initialize tab

           perform varying i from 0 by 1 until i > length-a
              move i to costs(i + 1, 1)
           end-perform

           perform varying j from 0 by 1 until j > length-b
              move j to costs(1, j + 1)
           end-perform

           perform with test after varying i from 2 by 1 until i > length-a
              perform with test after varying j from 2 by 1 until j > length-b
                 if string-a(i - 1:1) = string-b(j - 1:1)
                    move costs(i - 1, j - 1) to costs(i, j)
                 else
                    move min(min(costs(i - 1, j) + 1,     *> a deletion
                                 costs(i, j - 1) + 1),    *> an insertion
                             costs(i - 1, j - 1) + 1)     *> a substitution
                       to costs(i, j)
                 end-if
              end-perform
           end-perform
           move costs(length-a + 1, length-b + 1) to distance
           display trim(string-a) " -> " trim(string-b) " = " trim(distance)
           .
