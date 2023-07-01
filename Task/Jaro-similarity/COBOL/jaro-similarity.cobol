       identification division.
       program-id. JaroDistance.

       environment division.
       configuration section.
       repository.
           function length intrinsic
           function trim intrinsic
           function max intrinsic
           function min intrinsic
           .

       data division.
       working-storage section.
       77  s                      pic x(255).
       77  t                      pic x(255).
       77  s-length               pic 9(3).
       77  t-length               pic 9(3).
       77  i                      pic 9(3).
       77  j                      pic 9(3).
       77  k                      pic 9(3).
       77  start-pos              pic 9(3).
       77  end-pos                pic 9(3).
       77  match-distance         pic 9(3).
       77  matches                pic 9(3).
       77  transpositions         pic 9(3).
       77  distance               pic 9v9(8).

       01  jaro-table.
           05 filler              occurs 255.
              10 filler           pic 9(1).
                 88 s-matches     value 1 when set to false is 0.
              10 filler           pic 9(1).
                 88 t-matches     value 1 when set to false is 0.

       procedure division.
       main.
           move "MARTHA" to s
           move "MARHTA" to t
           perform jaro-calc-and-show
           move "DIXON" to s
           move "DICKSONX" to t
           perform jaro-calc-and-show
           move "JELLYFISH" to s
           move "SMELLYFISH" to t
           perform jaro-calc-and-show
           stop run
           .
       jaro-calc-and-show.
           perform jaro-distance
           display trim(s) " -> " trim(t) ", distance=" distance
           .
       jaro-distance.
           move length(trim(s)) to s-length
           move length(trim(t)) to t-length
           if s-length = zeros and t-length = zeros
              move 1 to distance
              exit paragraph
           end-if

           compute match-distance = max(s-length, t-length) / 2 - 1
           move low-values to jaro-table
           move zeros to matches
           move zeros to transpositions
           perform varying i from 1 by 1 until i > s-length
              move max(1, i - match-distance) to start-pos
              move min(i + match-distance, t-length) to end-pos
              perform varying j from start-pos by 1 until j > end-pos
                 if t-matches(j) or s(i:1) <> t(j:1)
                    exit perform cycle
                 end-if,
                 set s-matches(i), t-matches(j) to true
                 add 1 to matches
                 exit perform
              end-perform
           end-perform
           if matches = zeros
              move matches to distance
              exit paragraph
           end-if

           move 1 to k
           perform varying i from 1 by 1 until i > s-length
              if not s-matches(i)
                 exit perform cycle
              end-if
              perform until t-matches(k)
                 add 1 to k
              end-perform
              if s(i:1) <> t(k:1)
                 add 1 to transpositions
              end-if
              add 1 to k
           end-perform

           compute distance = ((matches / s-length) + (matches / t-length) +
                               ((matches - transpositions / 2) / matches)) / 3
           .
