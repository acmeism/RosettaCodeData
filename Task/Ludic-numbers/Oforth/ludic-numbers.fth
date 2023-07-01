: ludic(n)
| ludics l p |
   ListBuffer newSize(n) seqFrom(2, n) over addAll ->l
   ListBuffer newSize(n) dup add(1) dup ->ludics

   while(l notEmpty) [
      l removeFirst dup ludics add ->p
      l size p / p * while(dup 1 > ) [ dup l removeAt drop p - ] drop
      ] ;

: ludics
| l i |
   ludic(22000) ->l
   "First 25     : " print l left(25) println
   "Below 1000   : " print l filter(#[ 1000 < ]) size println
   "2000 to 2005 : " print l extract(2000, 2005) println

   250 loop: i [
      l include(i) ifFalse: [ continue ]
      l include(i 2 +) ifFalse: [ continue ]
      l include(i 6 +) ifFalse: [ continue ]
      i print ", " print i 2 + print ", " print i 6 + println
      ] ;
